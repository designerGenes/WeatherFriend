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
    
}

class MockWeatherViewModel: ObservableObject, WeatherViewModelType {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = "90210"
    @Published var messages: [OpenAIConversationMessage] = []
    @Published var isShowingMessages: Bool = false
    
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
    
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    
    
    init(usesFahrenheit: Bool = true) {
        self.usesFahrenheit = usesFahrenheit
        
        $zipCode
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        
            .sink { debouncedZipCode in
                guard debouncedZipCode.allSatisfy({ $0.isNumber }) && debouncedZipCode.count == 5 else {
                    return
                }
                Task {
                    do {
                        guard let weather = try? await AppleWeatherController.sharedInstance.getWeather(forZipCode: self.zipCode) else {
                            return
                        }
                        let sessionTimestamp = Date().timeIntervalSince1970.description
                        OpenAIController.sharedInstance.currentConversationTimestamp = sessionTimestamp
                        try await OpenAIController.sharedInstance.sendOpeningMessage(weather: weather,
                                                                                     zipCode: self.zipCode,
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
            .store(in: &cancellables)
        
    }
}
