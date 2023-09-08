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
    var weather: WeatherType? { get set }
    func reset() async
    func submitZipcode(zipCode: String)
    func didSubmitConversationCommand(view: OpenAIConversationViewType, command: OpenAICommand) async
    
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
    func didSubmitConversationCommand(view: OpenAIConversationViewType, command: OpenAICommand) async {
        switch command {
        default:
            break
        }
    }
    
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
    
    func didSubmitConversationCommand(view: OpenAIConversationViewType, command: OpenAICommand) async {
        var conversationMessage: OpenAIConversationMessage?
        switch command {
        case .yes:
            conversationMessage = OpenAIConversationMessage(content: OpenAICommand.yes.fullText(), role: .user)
        case .no:
            conversationMessage = OpenAIConversationMessage(content: OpenAICommand.no.fullText(), role: .user)
        case .retry:
            conversationMessage = OpenAIConversationMessage(content: OpenAICommand.retry.fullText(), role: .user)
        default:
            break
        }
        conversationMessage?.sessionTimestamp = OpenAIController.sharedInstance.currentConversationTimestamp
        guard let conversationMessage = conversationMessage else {
            return // error handling?
        }
        try? await OpenAIController.sharedInstance.sendMessage(message: conversationMessage)
        await MainActor.run {
            self.messages = OpenAIConversationMessageRepository.getAll(sessionTimestamp: OpenAIController.sharedInstance.currentConversationTimestamp)
        }
    }
    
    func submitZipcode(zipCode: String) {
        
        Future<Any, Never> { completion in
            
        }
        
        
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
        $zipCode
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { value in
                guard value.allSatisfy({ $0.isNumber}) && value.count == 5 else {
                    return
                }
                
                self.submitZipcode(zipCode: value)
            }
            .store(in: &cancellables)
    }
}
