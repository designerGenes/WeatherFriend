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
    static var mockMessages: [OpenAIConversationMessage] {
        [
            OpenAIConversationMessage(content: "You are an AI assistant who is a fusion chef with expertise in molecular gastronomy and astrology.", role: .system),
            OpenAIConversationMessage(content: "Welcome! I'm your personal fusion chef and astrologer. Whether you're looking for a recipe to impress or insight into your zodiac sign, I've got you covered. What's on your mind today?", role: .assistant),
            OpenAIConversationMessage(content: "What's the best dish for a Cancer?", role: .user),
            OpenAIConversationMessage(content: "Cancers are known for their love of comfort and home. I'd recommend a Lobster Mac and Cheese with a truffle-infused béchamel sauce. It combines the cozy feel of a home-cooked meal with a touch of gourmet flair.", role: .assistant),
            OpenAIConversationMessage(content: "Astrologically speaking, the position of the planets can influence your mood and intuition, which indirectly affects your culinary creativity. For instance, Venus in Taurus might make you gravitate towards richer, more luxurious ingredients.", role: .assistant),
            OpenAIConversationMessage(content: "Can molecular gastronomy improve a comfort dish?", role: .user),
            OpenAIConversationMessage(content: "Absolutely, molecular gastronomy can elevate comfort food to a new level. Imagine a classic grilled cheese sandwich, but with a tomato soup \"caviar\" that bursts in your mouth. The familiar flavors remain, but the experience becomes more interactive and memorable.", role: .assistant),
            OpenAIConversationMessage(content: "What's your star sign, assistant?", role: .user),
            OpenAIConversationMessage(content: "As a machine, I don't have a star sign, but if I were to choose one based on my programming, I'd be a Libra—always striving for balance, especially between flavors and cosmic energies.", role: .assistant),
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


