//
//  OpenAIConversationMessage.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation
import RealmSwift
import RealmSwift


class OpenAIConversationMessage: Object, Codable {
    
    @Persisted var timestamp: String
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
        case timestamp
        case content
        case role
    }
    
    // Decode
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        timestamp = try container.decode(String.self, forKey: .timestamp)
        content = try container.decode(String.self, forKey: .content)
        roleString = try container.decode(String.self, forKey: .role)
    }
    
    // Encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(content, forKey: .content)
        try container.encode(role.rawValue, forKey: .role)
    }
}


class OpenAIConversationMessageRepository: Repository {
    typealias T = OpenAIConversationMessage
    let realm: Realm
    
    static let shared: OpenAIConversationMessageRepository = OpenAIConversationMessageRepository(realm: try! Realm())
    
    init(realm: Realm) {
        self.realm = try! Realm()
    }
    func get(id: String) -> OpenAIConversationMessage? {
        let message = realm.object(ofType: OpenAIConversationMessage.self, forPrimaryKey: id)
        return message
    }
    
    func getAll(timestamp: String, role: OpenAIRole? = nil) -> [OpenAIConversationMessage] {
        let messages = realm.objects(OpenAIConversationMessage.self).filter("timestamp == %@", timestamp)
        if let role = role {
            return Array(messages).filter({$0.role == role})
        }
        return Array(messages)
    }
    
    func getAll() -> [OpenAIConversationMessage] {
        let messages = realm.objects(OpenAIConversationMessage.self)
        return Array(messages)
    }
    
    func add(_ value: OpenAIConversationMessage) {
        do {
            try realm.write {
                realm.add(value)
            }
        } catch {
            // error handling
        }
    }
    
    func update(_ value: OpenAIConversationMessage) {
        do {
            try realm.write {
                realm.add(value, update: .modified)
            }
        } catch {
            print("Error updating user: \(error)")
        }
    }
    
    func delete(id: String) {
        guard let message = get(id: id) else {
            return // error handling
        }
        do {
            try realm.write {
                realm.delete(message)
            }
        } catch {
            
        }
    }
}
