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
