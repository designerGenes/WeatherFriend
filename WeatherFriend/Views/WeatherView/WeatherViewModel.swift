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
    private let debounce = Debounce(seconds: 0.5)
    private let messageRepository = OpenAIConversationMessageRepository.shared
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private func submitZipcodeAndInitConversation() async -> Future<OpenAIConversationMessage?, Error> {
        let task = Task {
            let weather = try? await AppleWeatherController.sharedInstance.getWeather(forZipCode: zipCode)
            guard let weather = weather else {
                return // error handling
            }
            let message = try? await OpenAIController.sharedInstance.sendOpeningMessage(weather: weather, zipCode: zipCode, command: conversationCommand)
            // TODO: refresh list based on database query
        }
        
        return Future { _ in
            task()
        }
    }
    
    private func submitMessage() async -> Future<[OpenAIConversationMessage], Error> {
        
    }
    
    init(usesFahrenheit: Bool = true) {
        self.usesFahrenheit = usesFahrenheit
        
        messageRepository.getAll(timestamp: /*<#T##String#>*/)
        
        $zipCode
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .
        
            .flatMap{ debouncedZipCode in
                
            }
            .flatMap { [weak self] debouncedZipCode -> AnyPublisher<OpenAIConversationMessage?, Error> in
                guard let self = self, debouncedZipCode.count == 5 else {
                    
                    return Just(nil).eraseToAnyPublisher()
                }
                
                return submitZipcodeAndInitConversation()
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
