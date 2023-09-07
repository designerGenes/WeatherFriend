//
//  WeatherType.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/17/23.
//

import Foundation
import WeatherKit


protocol WeatherType {
    var condition: WeatherCondition { get set }
    var humidity: Double { get set }
    var temperature: Measurement<UnitTemperature> { get set }
    var windDirection: Wind.CompassDirection { get }
    var windSpeed: Measurement<UnitSpeed> { get }
    
}

extension WeatherType {
    func setScene() -> String {
        let tempUnit: String
        switch temperature.unit {
        case .celsius: tempUnit = "celsius"
        case .fahrenheit: tempUnit = "fahrenheit"
        case .kelvin: tempUnit = "kelvin"
        default:
            return "" // error handling
        }
        return "It is \(temperature.value) degrees \(tempUnit) and \(condition.description)"
    }
}

struct MockWeatherType: WeatherType {
    var condition: WeatherCondition
    var humidity: Double
    var temperature: Measurement<UnitTemperature>
    var windDirection: Wind.CompassDirection
    var windSpeed: Measurement<UnitSpeed>
    
    
    static func mock() -> MockWeatherType {
        return MockWeatherType(condition: WeatherCondition.breezy, humidity: 0.5, temperature: .init(value: 55, unit: .fahrenheit), windDirection: Wind.CompassDirection.east, windSpeed: Measurement(value: 10, unit: .metersPerSecond))
    }
}

extension CurrentWeather: WeatherType {
    var windDirection: Wind.CompassDirection {
        return self.wind.compassDirection
    }
    
    var windSpeed: Measurement<UnitSpeed> {
        return self.wind.speed
    }
}

extension WeatherType {
    
    
    func buildWeatherCondition() -> String {
        var out = ""
        var components: [String] = []

        if temperature.converted(to: .fahrenheit).value > 85 {
            components.append("hot")
        } else if temperature.converted(to: .fahrenheit).value > 70 {
            components.append("warm")
        } else if temperature.converted(to: .fahrenheit).value > 50 {
            components.append("cool")
        } else if temperature.converted(to: .fahrenheit).value > 30 {
            components.append("cold")
        } else {
            components.append("freezing")
        }
        
        if windSpeed.value > 20 {
            components.append("very windy")
        } else if windSpeed.value > 10 {
            components.append("windy")
        } else if windSpeed.value > 5 {
           components.append("breezy")
        }
        
        if humidity > 80 {
            components.append("humid")
        } else if humidity > 60 {
            components.append("muggy")
        } else if humidity > 40 {
            components.append("dry")
        } else if humidity > 20 {
            components.append("very dry")
        }
        
        
        components.append(condition.description)
        
        for (x, val) in components.enumerated() {
            let prefix = x == 0 ? "" : " and "
            out += "\(prefix)\(val)"
        }
        
        return out.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

