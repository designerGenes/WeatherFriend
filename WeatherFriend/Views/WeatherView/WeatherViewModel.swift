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
    var isShowingShelf: Bool { get set }
    
}

class MockWeatherViewModel: ObservableObject, WeatherViewModelType {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = "90210"
    @Published var messages: [OpenAIConversationMessage] = []
    @Published var isShowingShelf: Bool = false
    
    static func mock() -> MockWeatherViewModel {
        return MockWeatherViewModel()
    }
}

class WeatherViewViewModel: ObservableObject, WeatherViewModelType {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = ""
    @Published var messages: [OpenAIConversationMessage] = []
    @Published var isShowingShelf: Bool = false
    @Published var conversationCommand: OpenAICommand = .whatToDo
    private let messageRepository = OpenAIConversationMessageRepository.shared
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private func submitZipcodeAndInitConversation() async throws -> Bool {
        let sessionTimestamp = Date().timeIntervalSince1970.description
        guard let weather = try? await AppleWeatherController.sharedInstance.getWeather(forZipCode: zipCode) else {
            return false
        }
      
      try? await OpenAIController.sharedInstance.sendOpeningMessage(weather: weather, zipCode: zipCode, command: conversationCommand, sessionTimestamp: sessionTimestamp)
      self.messages = self.messageRepository.getAll(sessionTimestamp: sessionTimestamp)
      return true
    }
    
    init(usesFahrenheit: Bool = true) {
        self.usesFahrenheit = usesFahrenheit

        $zipCode
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { debouncedZipCode in
                guard debouncedZipCode.count == 5 else {
                    return
                }
                // hide textfield
                
                // make initial query
                OpenAIController.sharedInstance.currentConversationTimestamp = Date().timeIntervalSince1970.description
                let submissionTask = Task {
                    try? await self.submitZipcodeAndInitConversation()
                }
            }
            .store(in: &cancellables)
        
    }
}
