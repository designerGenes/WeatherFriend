//
//  OpenAIController.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation
import SwiftyJSON



protocol OpenAIControllerType {
    
}

final class OpenAIController: OpenAIControllerType {
    static let sharedInstance = OpenAIController()
    
    var currentConversationTimestamp: String = Date().timeIntervalSince1970.description
    
    func compressedMessageHistory(sessionTimestamp: String) -> [OpenAIConversationMessage] {
        return OpenAIConversationMessageRepository.shared.getAll(sessionTimestamp: sessionTimestamp, role: .assistant)
    }
    
    private var lambdaURL: URL {
        let contentUrls: [String: String] = Bundle.main.plistValue(for: .contentURLs)
        return URL(string: contentUrls[PlistKey.awsBaseURL.rawValue]!)!
    }
    
    func handleReceivedMessage(message: OpenAIConversationMessage) {
        OpenAIConversationMessageRepository.shared.add(message)
            
    }
    
    func sendMessage(message: OpenAIConversationMessage) async throws {
        /**
         {
             "model": "gpt-3.5-turbo",
             "messages": [{
                 "role": "system",
                 "content": "you are a cowboy"
             }],
             "newMessage": {
                 "role": "user",
                 "content": "Hey there partner"
             }
         }
         
         */
        
        OpenAIConversationMessageRepository.shared.add(message)
        let sessionTimestamp = message.sessionTimestamp
        var request = URLRequest(url: lambdaURL)
        request.setHTTPMethod(.POST)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let messageHistory = compressedMessageHistory(sessionTimestamp: currentConversationTimestamp)
        
        let model = "gpt-3.5-turbo"
        let body: JSON = [
            "model": model,
            "messages": JSON(messageHistory.map({$0.toSendable()})),
            "newMessage": JSON(message.toSendable())
        ]
        
        
        
        print("sending messages: \(messageHistory.map({$0.content}))")
        print("sending new message: \(message.content)")
        request.httpBody = try body.rawData()
        do {
            print("sending request:\n\(request.description)")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                print(response.description)
                return // error handling
            }
            guard let receivedMessage = try? JSONDecoder().decode(LambdaResponse.self, from: data) else {
                return
            }
            let decodedMessage = OpenAIConversationMessage(content: receivedMessage.content.content, role: OpenAIRole(rawValue: receivedMessage.content.role)!, sessionTimestamp: sessionTimestamp)
            
            handleReceivedMessage(message: decodedMessage)
        } catch {
            
        }
    }
    
    func sendOpeningMessage(weather: WeatherType, zipCode: String, command: OpenAICommand, sessionTimestamp: String) async throws {
        // personality : prime D : set scene : command
        let personality = OpenAIPersonality.jim.fullText()
        let primeDirective = OpenAIClarifier.primeDirective.fullText()
        let command = command.fullText()
        let scene = weather.setScene()
        let messageText = "\(personality)  \(primeDirective) \(scene) in the zipcode of \(zipCode).  \(command)"
        var message = OpenAIConversationMessage(content: messageText, role: .system, sessionTimestamp: sessionTimestamp) // auto generate sessionTimestamp
        
        return try await sendMessage(message: message)
    }
}
