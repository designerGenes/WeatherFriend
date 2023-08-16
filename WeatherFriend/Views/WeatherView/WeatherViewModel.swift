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

typealias FullWeatherResponse = (advice: WeatherAdvice?, snapshot: Weather?)

class WeatherViewViewModel: ObservableObject {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = ""
    @Published var weatherSnapshot: Weather?
    @Published var weatherAdvice: WeatherAdvice?
    
    private func buildWeatherCondition(weatherSnapshot: Weather) -> String {
        var out = ""
        var components: [String] = []

        if weatherSnapshot.currentWeather.temperature.converted(to: .fahrenheit).value > 85 {
            components.append("hot")
        } else if weatherSnapshot.currentWeather.temperature.converted(to: .fahrenheit).value > 70 {
            components.append("warm")
        } else if weatherSnapshot.currentWeather.temperature.converted(to: .fahrenheit).value > 50 {
            components.append("cool")
        } else if weatherSnapshot.currentWeather.temperature.converted(to: .fahrenheit).value > 30 {
            components.append("cold")
        } else {
            components.append("freezing")
        }
        
        if weatherSnapshot.currentWeather.wind.speed.value > 20 {
            components.append("very windy")
        } else if weatherSnapshot.currentWeather.wind.speed.value > 10 {
            components.append("windy")
        } else if weatherSnapshot.currentWeather.wind.speed.value > 5 {
           components.append("breezy")
        }
        
        if weatherSnapshot.currentWeather.humidity > 80 {
            components.append("humid")
        } else if weatherSnapshot.currentWeather.humidity > 60 {
            components.append("muggy")
        } else if weatherSnapshot.currentWeather.humidity > 40 {
            components.append("dry")
        } else if weatherSnapshot.currentWeather.humidity > 20 {
            components.append("very dry")
        }
        
        
        components.append(weatherSnapshot.currentWeather.condition.description)
        
        for (x, val) in components.enumerated() {
            let prefix = x == 0 ? "" : " and "
            out += "\(prefix)\(val)"
        }
        
        return out.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    private func aiWeatherAdviceURL(weatherSnapshot: Weather) -> URL? {
        let urlBase = Bundle.main.object(forInfoDictionaryKey: PlistKey.awsBaseURL.rawValue) as! String
        var urlComponents = URLComponents(string: urlBase)
        
        let weatherTempDescription = String(describing: weatherSnapshot.currentWeather.temperature.converted(to: self.usesFahrenheit ? .fahrenheit : .celsius))
        let weatherCondition = buildWeatherCondition(weatherSnapshot: weatherSnapshot)
        urlComponents?.queryItems = [
            "zipCode".queryItem(self.zipCode),
            "weatherTemp".queryItem(weatherTempDescription),
            "weatherCondition".queryItem(weatherCondition),
        ]

        return urlComponents?.url
    }
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func getWeatherAdviceFromAWS(weatherSnapshot: Weather) async throws -> WeatherAdvice {
        
        guard let url = aiWeatherAdviceURL(weatherSnapshot: weatherSnapshot) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        let responseString = openAIResponse.choices.first?.message.content
        return WeatherAdvice(advice: responseString ?? "No advice, sorry")
    }
        
    func getCurrentAppleWeather() async throws -> Weather? {
        let controller = WeatherKitController()
        let weather = try await controller.getWeather(forZipCode: zipCode)
        return weather
    }
    
    init(usesFahrenheit: Bool = true, weatherSnapshot: Weather? = nil) {
        self.usesFahrenheit = usesFahrenheit
        self.weatherSnapshot = weatherSnapshot
        
        $zipCode
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { [weak self] debouncedZipCode -> AnyPublisher<FullWeatherResponse?, Never> in
                guard debouncedZipCode.count == 5, let self = self else {
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
