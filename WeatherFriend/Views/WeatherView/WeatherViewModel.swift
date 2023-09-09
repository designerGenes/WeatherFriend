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

protocol WeatherViewModelType: ObservableObject, OpenAIConversationViewDelegate {
    var usesFahrenheit: Bool { get set }
    var zipCode: String { get set }
    var messages: [OpenAIConversationMessage] { get set }
    var isShowingMessages: Bool { get set }
    var isShowingConversationCommands: Bool { get set }
    var loadingProgress: Double { get set }
    var weather: WeatherType? { get set }
    func reset() async
    func submitZipcode(zipCode: String) async
    func didSubmitConversationCommand(view: OpenAIConversationViewType, command: OpenAICommand) async
    
}

extension WeatherViewModelType {
    func reset() {
        DispatchQueue.main.async {
            self.messages.removeAll()
            self.weather = nil
            self.isShowingMessages = false
            self.loadingProgress = -1
            self.isShowingConversationCommands = true
        }
        
    }
}

class MockWeatherViewModel: ObservableObject, WeatherViewModelType {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = "1234"
    @Published var messages: [OpenAIConversationMessage] = OpenAIConversationMessage.mockMessages
    @Published var isShowingMessages: Bool = true
    @Published var weather: WeatherType? = MockWeatherType.mock()
    @Published var loadingProgress: Double = 0.6
    @Published var isShowingConversationCommands: Bool = true
    
    func submitZipcode(zipCode: String) {
        //
    }
    static func mock() -> MockWeatherViewModel {
        return MockWeatherViewModel()
    }
    
    func didSubmitConversationCommand(view: OpenAIConversationViewType, command: OpenAICommand) async {
        switch command {
        default:
            break
        }
    }
}

class WeatherViewViewModel: ObservableObject, WeatherViewModelType {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = ""
    @Published var messages: [OpenAIConversationMessage] = []
    @Published var isShowingMessages: Bool = false
    @Published var isShowingConversationCommands: Bool = true
    @Published var loadingProgress: Double = -1
    @Published var conversationCommand: OpenAICommand = .whatToDo
    @Published var weather: WeatherType?
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func didSubmitConversationCommand(view: OpenAIConversationViewType, command: OpenAICommand) async {
        let conversationHistory = await OpenAIConversationMessageRepository.getAll(sessionTimestamp: OpenAIController.sharedInstance.currentConversationTimestamp, role: .user)
        if conversationHistory.count > 5 {
            let exceededMessage = OpenAIConversationMessage.conversationOverMessage
            self.messages.append(exceededMessage)
            self.isShowingConversationCommands = false
            return
        }
        
        if command == .retry {
            self.reset()
            await self.submitZipcode(zipCode: self.zipCode)
            return
        }
        
        let conversationMessage = OpenAIConversationMessage(content: command.fullText(), role: .user, sessionTimestamp: OpenAIController.sharedInstance.currentConversationTimestamp)
        self.loadingProgress = 0.5
        await OpenAIController.sharedInstance.sendMessage(message: conversationMessage)
        self.loadingProgress = 0.75
        self.messages = await OpenAIConversationMessageRepository.getAll(sessionTimestamp: OpenAIController.sharedInstance.currentConversationTimestamp)
        self.isShowingMessages = true
        self.loadingProgress = -1
    }
    
    func submitZipcode(zipCode: String) async {
        self.loadingProgress = 0.25
        guard let weather = try? await AppleWeatherController.sharedInstance.getWeather(forZipCode: zipCode) else {
            self.loadingProgress = -1
            return
        }
        
        self.weather = weather
        let sessionTimestamp = Date().timeIntervalSince1970.description
        OpenAIController.sharedInstance.currentConversationTimestamp = sessionTimestamp
        await OpenAIController.sharedInstance.sendOpeningMessage(weather: weather,
                                                                     zipCode: zipCode,
                                                                     command: conversationCommand,
                                                                     sessionTimestamp: sessionTimestamp)
        self.loadingProgress = 0.75
        self.messages = await OpenAIConversationMessageRepository.getAll(sessionTimestamp: sessionTimestamp)
        self.isShowingMessages = true
        self.loadingProgress = -1
    }
    
    init(usesFahrenheit: Bool = true) {
        self.usesFahrenheit = usesFahrenheit
        
        $zipCode
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { value in
                guard value.allSatisfy({ $0.isNumber}) && value.count == 5 else {
                    return
                }
                Task {
                    await self.submitZipcode(zipCode: value)
                }
            }
            .store(in: &cancellables)
    }
}
