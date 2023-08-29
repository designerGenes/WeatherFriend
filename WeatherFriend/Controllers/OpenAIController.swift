//
//  OpenAIController.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation

protocol OpenAIControllerType {
    func sendMessage(message: OpenAIConversationMessage) async
}

final class OpenAIController: OpenAIControllerType {
    func sendMessage(message: OpenAIConversationMessage) async {
        <#code#>
    }
    
    static let shared = OpenAIController()
    
}
