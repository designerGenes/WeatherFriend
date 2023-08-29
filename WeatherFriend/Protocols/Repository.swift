//
//  Repository.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation


protocol Repository {
    associatedtype T
    func get(id: String) -> T?
    func getAll() -> [T]
    func add(_ value: T)
    func update(_ value: T)
    func delete(id: String)
}
