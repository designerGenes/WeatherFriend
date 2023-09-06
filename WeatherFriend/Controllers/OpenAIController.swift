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
    
    private func compressedMessageHistory(sessionTimestamp: String) async -> [OpenAIConversationMessage] {
      let messageHistory = await withCheckedContinuation { continuation in
        DispatchQueue.main.async {
          let messages = OpenAIConversationMessageRepository.getAll(sessionTimestamp: sessionTimestamp, role: .assistant)
          continuation.resume(returning: messages)
        }
      }

      return messageHistory
    }
    
    private var lambdaURL: URL {
        let contentUrls: [String: String] = Bundle.main.plistValue(for: .contentURLs)
        return URL(string: contentUrls[PlistKey.awsBaseURL.rawValue]!)!
    }
    
    func sendMessage(message: OpenAIConversationMessage) async throws {
        let messageHistory = await compressedMessageHistory(sessionTimestamp: currentConversationTimestamp)

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messageHistory.map({$0.toSendable()}),
            "newMessage": message.toSendable()
        ]
        
        AF.request(lambdaURL.absoluteString,
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .publishDecodable(type: LambdaResponse.self, queue: .main, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                break
            }
        }, receiveValue: { lambdaResponse in
            guard let lambdaResponseValue = lambdaResponse.value else {
                return // error handling
            }
            let receivedMessage = OpenAIConversationMessage.fromLambdaResponse(lambdaResponseValue, sessionTimestamp: message.sessionTimestamp)
            do {
                try OpenAIConversationMessageRepository.add(values: [message, receivedMessage])
            } catch {
                print(error)
            }
            
        })
        .store(in: &cancellables)
    }
            
    func sendOpeningMessage(weather: WeatherType, zipCode: String, command: OpenAICommand, sessionTimestamp: String) async throws {
        // personality : prime D : set scene : command
        let personality = OpenAIPersonality.jim.fullText()
        let primeDirective = OpenAIClarifier.primeDirective.fullText()
        let command = command.fullText()
        let scene = weather.setScene()
        let messageText = "\(personality)  \(primeDirective) \(scene) in the zipcode of \(zipCode).  \(command)"
        let message = OpenAIConversationMessage(content: messageText, role: .system, sessionTimestamp: sessionTimestamp) // auto generate sessionTimestamp
        
        return try await sendMessage(message: message)
    }
}
