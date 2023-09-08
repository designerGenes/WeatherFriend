//
//  OpenAIConversationMessage.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation
import RealmSwift
import SwiftyJSON

struct LambdaResponse: Codable {
    let role: String
    let content: String
}

class OpenAIConversationMessage: Object, Codable, Identifiable {
    @Persisted var creationTimestamp: String
    @Persisted var sessionTimestamp: String
    @Persisted var content: String
    @Persisted var roleString: String
    
    var role: OpenAIRole {
        get {
            return OpenAIRole(rawValue: roleString)!
        }
        set {
            roleString = newValue.rawValue
        }
    }
    enum CodingKeys: String, CodingKey {
        case sessionTimestamp
        case creationTimestamp
        case content
        case role
    }
    
    func toSendable() -> [String: Any] {
        return [
            "role": self.roleString,
            "content": JSON(parseJSON: content).rawString() ?? "",
            "sessionTimestamp": self.sessionTimestamp
        ]
    }
    
    static func fromLambdaResponse(_ response: LambdaResponse, sessionTimestamp: String) -> OpenAIConversationMessage {
        // no need to set creationTimestamp because the creation time is when we received this message in a response
        OpenAIConversationMessage(content: response.content, role: OpenAIRole(rawValue:  response.role)!, sessionTimestamp: sessionTimestamp)
    }
    
    convenience init(content: String, role: OpenAIRole, sessionTimestamp: String = Date().timeIntervalSince1970.description) {
        self.init()
        self.content = content
        self.role = role
        self.sessionTimestamp = sessionTimestamp
        self.creationTimestamp = Date().timeIntervalSince1970.description
    }
    
    // Decode
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        creationTimestamp = try container.decode(String.self, forKey: .creationTimestamp)
        sessionTimestamp = try container.decode(String.self, forKey: .sessionTimestamp)
        content = try container.decode(String.self, forKey: .content)
        roleString = try container.decode(String.self, forKey: .role)
    }
    
    // Encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(creationTimestamp, forKey: .creationTimestamp)
        try container.encode(sessionTimestamp, forKey: .sessionTimestamp)
        try container.encode(content, forKey: .content)
        try container.encode(roleString, forKey: .role)
    }
}

extension OpenAIConversationMessage {
    static var conversationOverMessage: OpenAIConversationMessage {
        OpenAIConversationMessage(content: "This conversation has exceeded the token limit, but you can always start a new one!", role: .localSystem)
    }
}


extension OpenAIConversationMessage {
    static var mockMessages: [OpenAIConversationMessage] {
        [
            OpenAIConversationMessage(content: "You are an AI assistant who is an expert in local activities and events, with a knack for trivia about pies and metals.", role: .system),
            OpenAIConversationMessage(content: "What fun activities are there to do in the zip code 78666?", role: .user),
            OpenAIConversationMessage(content: "In the 78666 zip code, you can enjoy a live music performance at the Harmony Hall or take a kayak tour down Wobble Creek. For food enthusiasts, there's the annual BBQ Fest at Tasty Meadows.", role: .assistant),
            OpenAIConversationMessage(content: "That sounds interesting! What's special about the BBQ Fest at Tasty Meadows?", role: .user),
            OpenAIConversationMessage(content: "The BBQ Fest at Tasty Meadows is an annual event featuring pitmasters from across the region. It's known for its IronSmoke competition, where chefs create BBQ dishes incorporating unique types of metal cookware.", role: .assistant),
            OpenAIConversationMessage(content: "Metal cookware in a BBQ competition? How does that work?", role: .user),
            OpenAIConversationMessage(content: "Yes, it's quite unique! In the IronSmoke competition, chefs must use at least one piece of metal cookware like a cast-iron skillet or copper grilling basket. This adds a layer of complexity as different metals interact with heat and flavor differently.", role: .assistant),
            OpenAIConversationMessage(content: "That's fascinating. Speaking of metals, what's the best metal to use for baking pies?", role: .user),
            OpenAIConversationMessage(content: "Ah, when it comes to baking pies, aluminum pie pans are often considered the best. They conduct heat evenly, which is crucial for a perfectly baked crust. However, glass and ceramic pans are also popular choices for their heat retention properties.", role: .assistant),
            OpenAIConversationMessage(content: "Makes sense! Do you think aluminum pans could work in the IronSmoke competition?", role: .user),
            OpenAIConversationMessage(content: "Aluminum pans could work, but they wouldn't be the ideal choice for BBQ due to their lower melting point and heat tolerance compared to cast iron or stainless steel. They're great for pies, but not for the high-heat conditions of a BBQ competition.", role: .assistant)
        ]
    }
}

@MainActor
final class OpenAIConversationMessageRepository {
    
    // Single Realm instance
    static let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    
    typealias T = OpenAIConversationMessage
    
    static let shared = OpenAIConversationMessageRepository()
    
    static func get(id: String) -> T? {
        let object = OpenAIConversationMessageRepository.realm.object(ofType: T.self, forPrimaryKey: id)
        return object
    }
    
    static func getAll(sessionTimestamp: String, role: OpenAIRole? = nil) -> [OpenAIConversationMessage] {
        let messages = OpenAIConversationMessageRepository.realm.objects(OpenAIConversationMessage.self).filter("sessionTimestamp == %@", sessionTimestamp)
        
        if let role = role {
            return Array(messages).filter({$0.role == role}).map { $0.detached() }
        }
        
        return Array(messages).map { $0.detached() }
    }
    
    static func getAll() -> [T] {
        let objects = OpenAIConversationMessageRepository.realm.objects(OpenAIConversationMessage.self)
        return Array(objects)
    }
    
    static func add(values: [T]) throws {
        do {
            try self.realm.write {
                self.realm.add(values)
            }
        } catch {
            // error handling
            print("Error adding values: \(error)")
        }
    }
    
    static func add(_ value: T) throws {
        do {
            try self.realm.write {
                self.realm.add(value)
            }
        } catch {
            // error handling
            print("Error adding value: \(error)")
        }
    }
    
    static func delete(id: String) throws {
        guard let object = OpenAIConversationMessageRepository.realm.object(ofType: OpenAIConversationMessage.self, forPrimaryKey: id) else {
            return
        }
        
        do {
            try self.realm.write {
                self.realm.delete(object)
            }
        } catch {
            // error handling
            print("Error deleting object: \(error)")
        }
    }
}


