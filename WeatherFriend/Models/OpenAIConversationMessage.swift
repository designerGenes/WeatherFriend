//
//  OpenAIConversationMessage.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation
import RealmSwift

class OpenAIConversationMessage: Object {
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
}

class OpenAIConversationMessageRepository: Repository {
    typealias T = OpenAIConversationMessage
    let realm: Realm
    
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
