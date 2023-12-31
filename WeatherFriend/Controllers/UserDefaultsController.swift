//
//  UserDefaultsController.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/21/23.
//

import Foundation
import Security

enum UserDefaultsKey: String {
    case theme = "com.designergenes.weatherfriend.theme"
    case gptModel = "com.designergenes.weatherfriend.gptModel"
    case gptMaxTokens = "com.designergenes.weatherfriend.gptMaxTokens"
    case backgroundLastChangedTimestamp = "com.designergenes.backgroundLastChangedTimestamp"
    case backgroundLastImageName = "com.designergenes.backgroundLastImageName"
}

enum KeychainKey: String {
    case openAPIKey = "com.designergenes.weatherfriend.openAPIKey"
}


class UserDefaultsController {
    static func get<T>(key: UserDefaultsKey, default: T? = nil, conversionFunction: ((Any) -> T)? = nil) -> T? {
        guard let rawSavedDefault = UserDefaults.standard.object(forKey: key.rawValue) else {
            return nil
        }
        if let typedDefault = rawSavedDefault as? T {
            return typedDefault
        } else if let conversionFunction = conversionFunction {
            return conversionFunction(rawSavedDefault)
        }
        return nil
    }
    
    static func set(key: UserDefaultsKey, value: Any) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
}

class KeychainController {
    static let serviceName = "com.designergenes.weatherfriend"
    static func set(key: KeychainKey, value: String) {
        // save value to keychain with key
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: value.data(using: .utf8)!
        ]
        var result: CFTypeRef?
        SecItemAdd(query as CFDictionary, &result)
    }
    
    static func get(key: KeychainKey) -> String? {
        // get value from keychain with key
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if let retrievedData = dataTypeRef as? Data {
            let password = String(data: retrievedData, encoding: .utf8)
            return password
        }
        return nil
    }
    
}
