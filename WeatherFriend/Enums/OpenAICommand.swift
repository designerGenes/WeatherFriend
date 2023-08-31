//
//  OpenAICommand.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/25/23.
//

import Foundation


enum OpenAICommand: String {
    static var dictionary: [String: String] {
        let commandsObjectURL = Bundle.main.url(forResource: "OpenAI", withExtension: "json")!
        let commandsObjectData = try! Data(contentsOf: commandsObjectURL)
        return try! JSONDecoder().decode(Dictionary<String, String>.self, from: commandsObjectData)
    }
    
    case yes, no, tryAgain, whatToDo, whatToWear, whatToEat
    
    func fullText() -> String {
        let key: String
        switch self {
        case .no: key = "COMMAND_NO"
        case .yes: key = "COMMAND_YES"
        case .tryAgain: key = "COMMAND_TRY_AGAIN"
        case .whatToDo: key = "COMMAND_WHAT_TO_DO"
        case .whatToWear: key = "COMMAND_WHAT_TO_WEAR"
        case .whatToEat: key = "COMMAND_WHAT_TO_EAT"
        }
        return OpenAICommand.dictionary[key]!
    }
    
    
}

enum OpenAIPersonality: String {
    static var dictionary: [String: String] {
        let personalityObjectURL = Bundle.main.url(forResource: "OpenAI", withExtension: "json")!
        let personalityObjectData = try! Data(contentsOf: personalityObjectURL)
        return try! JSONDecoder().decode(Dictionary<String, String>.self, from: personalityObjectData)
    }
    
    case jim, pam, kev, pirate, cowboy, abuelita
    
    func fullText() -> String {
        let key: String
        switch self {
        case .jim: key = "PERSONALITY_JIM"
        case .pam: key = "PERSONALITY_PAM"
        case .cowboy: key = "PERSONALITY_COWBOY"
        case .pirate: key = "PERSONALITY_PIRATE"
        case .abuelita: key = "PERSONALITY_YOUR_ABUELITA"
        case .kev: key = "PERSONALITY_KEV"
            return OpenAIPersonality.dictionary[key]!
        }
    }
}

enum OpenAIClarifier: String {
    static var dictionary: [String: String] {
        let clarifierObjectURL = Bundle.main.url(forResource: "OpenAI", withExtension: "json")!
        let clarifierObjectData = try! Data(contentsOf: clarifierObjectURL)
        return try! JSONDecoder().decode(Dictionary<String, String>.self, from: clarifierObjectData)
    }
    
    case primeDirective, setScene
    
    func fullText() -> String {
        let key: String
        switch self {
        case .primeDirective: key = "CLARIFIER_PRIME_DIRECTIVE"
        case .setScene: key = "CLARIFIER_SET_SCENE"
        }
        return try! OpenAIClarifier.dictionary[key]!
    }
}
