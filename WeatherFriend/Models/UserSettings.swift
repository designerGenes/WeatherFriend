//
//  UserSettings.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/3/23.
//

import Foundation
import RealmSwift

class UserSettings: Object {
    @Persisted var usesFahrenheit: Bool
    @Persisted var colorScheme: String
    
}
