//
//  WeatherAdvice.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/10/23.
//

import Foundation

protocol WeatherAdviceType {
    var advice: String { get set }
}

struct MockWeatherAdvice: WeatherAdviceType {
    var advice: String
    
    static func mock() -> Self {
        return MockWeatherAdvice(advice: "Here is some damn fine weather advice")
    }
}

struct WeatherAdvice: Codable, WeatherAdviceType {
    var advice: String
    
}


protocol OpenAIResponseType {
    var choices: [Choice] { get set }
}

protocol ChoiceType {
    var message: Message { get set }
}

struct MockOpenAIResponse: OpenAIResponseType {
    var choices: [Choice]
    
    static func mock() -> Self {
        let message = Message(role: "agent", content: "This is a mock OpenAI Response Message")
        return MockOpenAIResponse(choices: [Choice(index: 0, message: message, finishReason: "finished")])
    }
}

struct OpenAIResponse: Decodable, OpenAIResponseType {
    var id: String
    var object: String
    var created: Int
    var model: String
    var choices: [Choice]
    var usage: Usage
}

struct Choice: Decodable, ChoiceType {
    var index: Int
    var message: Message
    var finishReason: String

    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct Message: Decodable {
    let role: String
    let content: String
}

struct Usage: Decodable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

