//
//  WeatherViewModel.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/10/23.
//

import Foundation
import SwiftUI
import Combine
import WeatherKit

typealias FullWeatherResponse = (advice: WeatherAdviceType?, snapshot: WeatherType?)


class WeatherViewViewModel: ObservableObject {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = ""
    @Published var weatherSnapshot: WeatherType?
    @Published var weatherAdvice: WeatherAdviceType?
    @Published var isShowingShelf: Bool = false
    private let controller = WeatherKitController()
    
    
    private func aiWeatherAdviceURL(weatherSnapshot: WeatherType) -> URL? {
        let urlBase = Bundle.main.object(forInfoDictionaryKey: PlistKey.awsBaseURL.rawValue) as! String
        var urlComponents = URLComponents(string: urlBase)
        
        let weatherTempDescription = String(describing: weatherSnapshot.temperature.converted(to: self.usesFahrenheit ? .fahrenheit : .celsius))
        
        urlComponents?.queryItems = [
            "zipCode".queryItem(self.zipCode),
            "weatherTemp".queryItem(weatherTempDescription),
            "weatherCondition".queryItem(weatherSnapshot.buildWeatherCondition()),
        ]

        return urlComponents?.url
    }
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func getWeatherAdviceFromAWS(weatherSnapshot: WeatherType) async throws -> WeatherAdvice {
        
        guard let url = aiWeatherAdviceURL(weatherSnapshot: weatherSnapshot) else {
            throw URLError(.badURL)
        }
        
        var openAIResponse: OpenAIResponseType?
        #if DEBUG
            openAIResponse = MockOpenAIResponse.mock()
        #else
        
            let (data, _) = try await URLSession.shared.data(from: url)
            openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        #endif

        let responseString = openAIResponse?.choices.first?.message.content
        return WeatherAdvice(advice: responseString ?? "No advice, sorry")
    }
        
    func getCurrentAppleWeather() async throws -> WeatherType? {
        print("getting current weather")
        var weather: WeatherType?
        #if DEBUG
            weather = MockWeatherType.mock()
        #else
            weather = try await controller.getWeather(forZipCode: zipCode)
        #endif
        
        return weather
    }
    
    init(usesFahrenheit: Bool = true, weatherSnapshot: WeatherType? = nil, weatherAdvice: WeatherAdviceType? = nil) {
        self.usesFahrenheit = usesFahrenheit
        self.weatherSnapshot = weatherSnapshot
        self.weatherAdvice = weatherAdvice
        
        $zipCode
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { [weak self] debouncedZipCode -> AnyPublisher<FullWeatherResponse?, Never> in
                guard let self = self, debouncedZipCode.count == 5 else {
                    self?.weatherSnapshot = nil
                    return Just(nil).eraseToAnyPublisher()
                }
                return Future { promise in
                    Task {
                        do {
                            let weather = try await self.getCurrentAppleWeather()
                            guard let weather = weather else {
                                print("failed to retrieve weather")
                                promise(.success(nil))
                                return
                            }
                            print("got weather with temp of \(weather)° Fahrenheit")
                            let adviceResponse = try await self.getWeatherAdviceFromAWS(weatherSnapshot: weather)
                            print("got advice of: \(adviceResponse.advice)")
                            promise(.success((advice: adviceResponse, snapshot: weather)))
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
                    self?.weatherSnapshot = fullResponse?.snapshot
                    self?.weatherAdvice = fullResponse?.advice
                }
            }
            .store(in: &self.cancellables)

    }
}
