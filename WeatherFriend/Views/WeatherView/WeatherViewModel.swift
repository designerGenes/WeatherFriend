//
//  WeatherViewModel.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/10/23.
//

import Foundation
import SwiftUI
import Combine

typealias FullWeatherResponse = (advice: WeatherAdvice?, moment: WeatherMoment?)

class WeatherViewViewModel: ObservableObject {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = ""
    @Published var weatherMoment: WeatherMoment?
    @Published var weatherAdvice: WeatherAdvice?
    private let API_KEY = Bundle.main.object(forInfoDictionaryKey: "WEATHERAPI_KEY") as! String
    
    private var currentWeatherURL: URL? {
        let urlBase = Bundle.main.object(forInfoDictionaryKey: "WEATHERAPI_BASE_URL") as! String
        var urlComponents = URLComponents(string: urlBase)
        urlComponents?.queryItems = [
            "key".queryItem(API_KEY),
            "q".queryItem(zipCode),
            "aqi".queryItem("yes")
        ]
        return urlComponents?.url
    }
    private func aiWeatherAdviceURL(weatherMoment: WeatherMoment) -> URL? {
        let urlBase = Bundle.main.object(forInfoDictionaryKey: "AWS_BASE_URL") as! String
        var urlComponents = URLComponents(string: urlBase)
        urlComponents?.queryItems = [
            "zipCode".queryItem(self.zipCode),
            "weatherTemp".queryItem(String(describing: weatherMoment.current.tempF)),
            "weatherCondition".queryItem(weatherMoment.current.condition.text.lowercased()),
        ]

        return urlComponents?.url
    }
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func getWeatherAdviceFromAWS(weatherMoment: WeatherMoment) async throws -> WeatherAdvice {
        
        guard let url = aiWeatherAdviceURL(weatherMoment: weatherMoment) else {
            throw URLError(.badURL)
        }
//        print("making AI advice request at: \(url.absoluteString)")
        let (data, _) = try await URLSession.shared.data(from: url)
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        let responseString = openAIResponse.choices.first?.message.content
        return WeatherAdvice(advice: responseString ?? "No advice, sorry")
    }
    
    func getCurrentWeather() async throws -> WeatherMoment {
        guard let url = currentWeatherURL else {
            throw URLError(.badURL)
        }
//        print("making weather request at: \(url.absoluteString)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherMoment.self, from: data)
    }
    
    init(usesFahrenheit: Bool = true, weatherMoment: WeatherMoment? = nil) {
        self.usesFahrenheit = usesFahrenheit
        self.weatherMoment = weatherMoment
        
        $zipCode
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { [weak self] debouncedZipCode -> AnyPublisher<FullWeatherResponse?, Never> in
                guard debouncedZipCode.count == 5, let self = self else {
                    self?.weatherMoment = nil
                    return Just(nil).eraseToAnyPublisher()
                }
                return Future { promise in
                    Task {
                        do {
                            let weather = try await self.getCurrentWeather()
                            print("got weather with temp of \(weather.current.tempF)° Fahrenheit")
                            let adviceResponse = try await self.getWeatherAdviceFromAWS(weatherMoment: weather)
                            print("got advice of: \(adviceResponse.advice)")
                            promise(.success((advice: adviceResponse, moment: weather)))
                        } catch {
                            print("error: \(error.localizedDescription)")
                            promise(.success(nil))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] fullResponse in
                DispatchQueue.main.async {
                    self?.weatherMoment = fullResponse?.moment
                    self?.weatherAdvice = fullResponse?.advice
                }
            }
            .store(in: &self.cancellables)

    }
}
