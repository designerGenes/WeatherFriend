//
//  Double+Conversion.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/7/23.
//

import Foundation

extension Double {
    var toFahrenheit: Double {
        return (self * (9/5)) + 32
    }
    
    var toCelsius: Double {
        return (self - 32) * (5/9)
    }
}
