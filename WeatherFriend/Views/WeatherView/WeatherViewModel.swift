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

protocol WeatherViewModelType: ObservableObject {
    var usesFahrenheit: Bool { get set }
    var zipCode: String { get set }
    var messages: [OpenAIConversationMessage] { get set }
    var isShowingMessages: Bool { get set }
    var weather: WeatherType? { get set }
    func reset() async
    func submitZipcode(zipCode: String)
    
}

extension WeatherViewModelType {
    func reset() async {
        await MainActor.run {
            self.messages.removeAll()
            self.weather = nil
            self.isShowingMessages = false
        }
    }
}

class MockWeatherViewModel: ObservableObject, WeatherViewModelType {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = "1234"
    @Published var messages: [OpenAIConversationMessage] = OpenAIConversationMessage.mockMessages
    @Published var isShowingMessages: Bool = true
    @Published var weather: WeatherType? = MockWeatherType.mock()
    func submitZipcode(zipCode: String) {
        //
    }
    static func mock() -> MockWeatherViewModel {
        return MockWeatherViewModel()
    }
}

class WeatherViewViewModel: ObservableObject, WeatherViewModelType {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = ""
    @Published var messages: [OpenAIConversationMessage] = []
    @Published var isShowingMessages: Bool = false
    @Published var conversationCommand: OpenAICommand = .whatToDo
    @Published var weather: WeatherType?
    
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func submitZipcode(zipCode: String) {
        Task {
            do {
                guard let weather = try? await AppleWeatherController.sharedInstance.getWeather(forZipCode: zipCode) else {
                    return
                }
                
                self.weather = weather
                let sessionTimestamp = Date().timeIntervalSince1970.description
                OpenAIController.sharedInstance.currentConversationTimestamp = sessionTimestamp
                try await OpenAIController.sharedInstance.sendOpeningMessage(weather: weather,
                                                                             zipCode: zipCode,
                                                                             command: self.conversationCommand,
                                                                             sessionTimestamp: sessionTimestamp)
                
                await MainActor.run {
                    self.messages = OpenAIConversationMessageRepository.getAll(sessionTimestamp: sessionTimestamp)
                }
            } catch {
                await MainActor.run {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    init(usesFahrenheit: Bool = true) {
        self.usesFahrenheit = usesFahrenheit
    }
}
