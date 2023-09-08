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

enum NetworkErrorType: Error {
    case someError
    case networkError(Error)
}

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
    
    private func didReceiveResponse(responseMessage: OpenAIConversationMessage, sentMessage: OpenAIConversationMessage) async {
        try? await OpenAIConversationMessageRepository.add(values: [sentMessage, responseMessage])
    }
    
    func sendMessage(message sentMessage: OpenAIConversationMessage) async  {
        let messageHistory = await compressedMessageHistory(sessionTimestamp: currentConversationTimestamp)
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messageHistory.map({$0.toSendable()}),
            "newMessage": sentMessage.toSendable()
        ]
        
        let requestFuture = Future<LambdaResponse, Error> { promise in
            AF.request(self.lambdaURL.absoluteString,
                       method: .post,
                       parameters: body,
                       encoding: JSONEncoding.default,
                       headers: ["Content-Type": "application/json"])
            .responseDecodable(of: LambdaResponse.self) { result in
                switch result.result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(NetworkErrorType.networkError(error)))
                }
            }
            
            
        }
        
        guard let lambdaResponse = try? await requestFuture.value else {
            return
        }
        
        let receivedMessage = OpenAIConversationMessage.fromLambdaResponse(lambdaResponse, sessionTimestamp: sentMessage.sessionTimestamp)
        try? await OpenAIConversationMessageRepository.add(values: [sentMessage, receivedMessage])
    }
    
    func sendOpeningMessage(weather: WeatherType, zipCode: String, command: OpenAICommand, sessionTimestamp: String) async {
        // personality : prime D : set scene : command
        let personality = OpenAIPersonality.jim.fullText()
        let primeDirective = OpenAIClarifier.primeDirective.fullText()
        let command = command.fullText()
        let scene = weather.setScene()
        let messageText = "\(personality)  \(primeDirective) \(scene) in the zipcode of \(zipCode).  \(command)"
        let message = OpenAIConversationMessage(content: messageText, role: .system, sessionTimestamp: sessionTimestamp) // auto generate sessionTimestamp
        
        await sendMessage(message: message)
    }
}
