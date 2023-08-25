//
//  Bundle+Assets.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/25/23.
//

import Foundation

extension Bundle {
    func plistValue<T>(for key: PlistKey) -> T {
        return self.object(forInfoDictionaryKey: key.rawValue) as! T
    }
}
