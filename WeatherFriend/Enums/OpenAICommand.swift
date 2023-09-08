//
//  OpenAICommand.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/25/23.
//

import Foundation

typealias DecodableHashable = Hashable & Decodable

enum OpenAIConstant: String {
    case commands, clarifiers, personalities
    case systemMessages = "system_messages"
    
    static var dictionary: [String: Dictionary<String, Decodable>] {
        let constantsObjectURL = Bundle.main.url(forResource: "OpenAI", withExtension: "json")!
        let constantsObjectData = try! Data(contentsOf: constantsObjectURL)
        
        let entireObject: [String: [String: String]] = try! JSONDecoder().decode([String: [String: String]].self, from: constantsObjectData)
        return entireObject
    }
    
    static func constants<T>(named constant: OpenAIConstant) -> Dictionary<String, T> {
        return dictionary[constant.rawValue]! as! Dictionary<String, T>
    }
}


enum OpenAICommand: String {
    case yes, no, retry, whatToDo, whatToWear, whatToEat
    
    func fullText() -> String {
        let key: String
        switch self {
        case .no: key = "COMMAND_NO"
        case .yes: key = "COMMAND_YES"
        case .retry: key = "COMMAND_TRY_AGAIN"
        case .whatToDo: key = "COMMAND_WHAT_TO_DO"
        case .whatToWear: key = "COMMAND_WHAT_TO_WEAR"
        case .whatToEat: key = "COMMAND_WHAT_TO_EAT"
        }
        return OpenAIConstant.constants(named: .commands)[key]!
    }
}

enum OpenAISystemMessage: String {
    case localConversationHitLimit
    
    func fullText() -> String {
        let key: String
        switch self {
        case .localConversationHitLimit: key = "LOCAL_CONVERSATION_HIT_LIMIT"
        }
        return OpenAIConstant.constants(named: .systemMessages)[key]!
    }

}

enum OpenAIPersonality: String {
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
            
        }
        return OpenAIConstant.constants(named: .personalities)[key]!
    }
}

enum OpenAIClarifier: String {
    case primeDirective, setScene
    
    func fullText() -> String {
        let key: String
        switch self {
        case .primeDirective: key = "CLARIFIER_PRIME_DIRECTIVE"
        case .setScene: key = "CLARIFIER_SET_SCENE"
        }
        return OpenAIConstant.constants(named: .clarifiers)[key]!
    }
}
