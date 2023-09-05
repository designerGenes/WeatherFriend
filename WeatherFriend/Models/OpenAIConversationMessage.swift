//
//  OpenAIConversationMessage.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation
import RealmSwift
import RealmSwift

struct LambdaResponse: Codable {
    let role: String
    let content: Content
    
    struct Content: Codable {
        let role: String
        let content: String
    }
}

class OpenAIConversationMessage: Object, Codable, Identifiable {
    
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
        case content
        case role
    }
    
    func toSendable() -> [String: String] {
        return [
            "role": self.roleString,
            "content": self.content,
            "sessionTimestamp": self.sessionTimestamp
        ]
    }
    
    convenience init(content: String, role: OpenAIRole, sessionTimestamp: String = Date().timeIntervalSince1970.description) {
        self.init()
        self.content = content
        self.role = role
        self.sessionTimestamp = sessionTimestamp
    }
    
    // Decode
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        sessionTimestamp = try container.decode(String.self, forKey: .sessionTimestamp)
        content = try container.decode(String.self, forKey: .content)
        roleString = try container.decode(String.self, forKey: .role)
    }
    
    // Encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(sessionTimestamp, forKey: .sessionTimestamp)
        try container.encode(content, forKey: .content)
        try container.encode(roleString, forKey: .role)
    }
}


class OpenAIConversationMessageRepository: Repository {
    typealias T = OpenAIConversationMessage
    let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)  // TMP! DEBUG!
    var realm: Realm {
        return try! Realm(configuration: configuration)
    }
        

    static let shared: OpenAIConversationMessageRepository = OpenAIConversationMessageRepository()

    init() {
        
    }

    func get(id: String) -> OpenAIConversationMessage? {
        autoreleasepool {
            let message = realm.object(ofType: OpenAIConversationMessage.self, forPrimaryKey: id)
            return message?.detached() // Assuming you have a method to detach the object
        }
    }

    func getAll(sessionTimestamp: String, role: OpenAIRole? = nil) -> [OpenAIConversationMessage] {
        autoreleasepool {
            let messages = realm.objects(OpenAIConversationMessage.self).filter("sessionTimestamp == %@", sessionTimestamp)
            if let role = role {
                return Array(messages).filter({$0.role == role}).map { $0.detached() }
            }
            return Array(messages).map { $0.detached() }
        }
    }

    func getAll() -> [OpenAIConversationMessage] {
        autoreleasepool {
            let messages = realm.objects(OpenAIConversationMessage.self)
            return Array(messages).map { $0.detached() }
        }
    }

    func add(_ value: OpenAIConversationMessage) {
        autoreleasepool {
            do {
                try realm.write {
                    realm.add(value)
                }
            } catch {
                // error handling
            }
        }
    }

    func update(_ value: OpenAIConversationMessage) {
        autoreleasepool {
            do {
                try realm.write {
                    realm.add(value, update: .modified)
                }
            } catch {
                print("Error updating user: \(error)")
            }
        }
    }

    func delete(id: String) {
        autoreleasepool {
            guard let message = realm.object(ofType: OpenAIConversationMessage.self, forPrimaryKey: id) else {
                return // error handling
            }
            do {
                try realm.write {
                    realm.delete(message)
                }
            } catch {
                // error handling
            }
        }
    }
}

