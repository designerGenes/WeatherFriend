//
//  OpenAIController.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation
import SwiftyJSON
import Alamofire
import Combine



protocol OpenAIControllerType {
    
}

final class OpenAIController: OpenAIControllerType {
    static let sharedInstance = OpenAIController()
    private var cancellables: Set<AnyCancellable> = Set()
    
    var currentConversationTimestamp: String = Date().timeIntervalSince1970.description
    
    private func compressedMessageHistory(sessionTimestamp: String) -> [OpenAIConversationMessage] {
        return OpenAIConversationMessageRepository.shared.getAll(sessionTimestamp: sessionTimestamp, role: .assistant)
    }
    
    private var lambdaURL: URL {
        let contentUrls: [String: String] = Bundle.main.plistValue(for: .contentURLs)
        return URL(string: contentUrls[PlistKey.awsBaseURL.rawValue]!)!
    }
    
    func sendMessage(message: OpenAIConversationMessage) async throws {
        OpenAIConversationMessageRepository.shared.add(message)
        let sessionTimestamp = message.sessionTimestamp
        let messageHistory = compressedMessageHistory(sessionTimestamp: currentConversationTimestamp)
        
        let model = "gpt-3.5-turbo"
        var messageContent: String = ""
        do {
            let jsonData = try JSONEncoder().encode(message.content)
            messageContent = String(data: jsonData, encoding: .utf8) ?? ""
            
        } catch {
            
        }
        
        
        
        
        let body: [String: Any] = [
            "model": model,
            "messages": [
                [
                "role": "assistant",
                "content": "here is a content message from the assistant",
                "sessionTimestamp": "123451243531"
                ]
            ],
            "newMessage": [
                "role": message.roleString,
                "content": message.content.replacingOccurrences(of: "\'", with: "\\'"),
                "sessionTimestamp": "123451243531"
            ]
        ]
        
        let url = "https://su6ww0a8yj.execute-api.us-west-2.amazonaws.com/prod/WeatherFriend"

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "assistant",
                    "content": "here is a content message from the assistant",
                    "sessionTimestamp": "12345678987654321"
                ]
            ],
            "newMessage": [
                "role": "user",
                "content": "here is a content message from the user",
                "sessionTimestamp": "12345678987654321"
            ]
        ]

        AF.request(url,
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .responseJSON { response in
            let result = response.result
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
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
