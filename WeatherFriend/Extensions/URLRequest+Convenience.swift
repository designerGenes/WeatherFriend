//
//  URLRequest+Convenience.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/29/23.
//

import Foundation

enum URLRequestType: String {
    case GET, POST, PUT, UPDATE
}

extension URLRequest {
    mutating func setHTTPMethod(_ methodType: URLRequestType) {
        self.httpMethod = methodType.rawValue
    }
    
    var description: String {
        "\(self.httpMethod ?? "nil") request\nURL: \(String(describing: self.url?.absoluteString ?? nil))\nHeaders: \(String(describing: self.allHTTPHeaderFields ?? nil))\nBody: \(String(describing: self.httpBody?.description ?? nil))"
    }
}
