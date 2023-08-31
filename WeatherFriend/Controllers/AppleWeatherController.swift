//
//  AppleWeatherController.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/31/23.
//

import Foundation
import Combine
import WeatherKit
import CoreLocation

protocol AppleWeatherControllerType {
    func getWeather(forZipCode zip: String) async throws -> WeatherType?
    static var sharedInstance: Self { get }
}

final class AppleWeatherController: AppleWeatherControllerType {
    static var sharedInstance = AppleWeatherController()
    
    private func zipcodeToLocation(_ zipcode: String) async -> CLLocation? {
        let geocoder = CLGeocoder()
        let addresses = try? await geocoder.geocodeAddressString(zipcode)
        
        guard let addresses = addresses, let location = addresses.first?.location else {
            return nil
        }
        return location
    
    }
    
    func getWeather(forZipCode zip: String) async throws -> WeatherType? {
        guard let location = await zipcodeToLocation(zip) else {
            return nil
        }
        let service = WeatherService()
        let weather = try await service.weather(for: location)
    
        return weather.currentWeather
      }
}
