//
//  OpenAIController.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation

protocol OpenAIControllerType {
    
}

final class OpenAIController: OpenAIControllerType {
    static let sharedInstance = OpenAIController()
    var currentConversationTimestamp: String = Date().timeIntervalSince1970.description
    
    func compressedMessageHistory(timestamp: String) -> [OpenAIConversationMessage] {
        return OpenAIConversationMessageRepository.shared.getAll(timestamp: timestamp, role: .assistant)
    }
    
    private var lambdaURL: URL {
        let urlString: String = Bundle.main.plistValue(for: .awsBaseURL)
        return URL(string: urlString)!
    }
    
    func handleReceivedMessage(message: OpenAIConversationMessage) {
        OpenAIConversationMessageRepository.shared.add(message)
            
    }
    
    func sendMessage(message: OpenAIConversationMessage) async throws {
        OpenAIConversationMessageRepository.shared.add(message)
        let timestamp = message.timestamp
        var request = URLRequest(url: lambdaURL)
        request.setHTTPMethod(.POST)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var messages: [OpenAIConversationMessage] = [message] + compressedMessageHistory(timestamp: currentConversationTimestamp)
        request.httpBody = try? JSONEncoder().encode(messages)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode), let receivedMessage = try? JSONDecoder().decode(OpenAIConversationMessage.self, from: data) else {
                return // error handling
            }
            receivedMessage.timestamp = timestamp
            handleReceivedMessage(message: receivedMessage)
        } catch {
            
        }
    }
    
    func sendOpeningMessage(weather: WeatherType, zipCode: String, command: OpenAICommand) async throws {
        // personality : prime D : set scene : command
        let personality = OpenAIPersonality.jim.fullText()
        let primeDirective = OpenAIClarifier.primeDirective.fullText()
        let command = command.fullText()
        let scene = weather.setScene()
        let messageText = "\(personality)  \(primeDirective) \(scene) in the zipcode of \(zipCode).  \(command)"
        var message = OpenAIConversationMessage(content: messageText)
        
        return try await sendMessage(message: message)
    }
}
