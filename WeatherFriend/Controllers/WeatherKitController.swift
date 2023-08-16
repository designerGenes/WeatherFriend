import Foundation
import WeatherKit
import CoreLocation

class WeatherKitController {
    private func zipcodeToLocation(_ zipcode: String) async -> CLLocation? {
        let geocoder = CLGeocoder()
        let addresses = try? await geocoder.geocodeAddressString(zipcode)
        
        guard let addresses = addresses, let location = addresses.first?.location else {
            return nil
        }
        return location
    
    }
    
    func getWeather(forZipCode zip: String) async throws -> Weather? {
        guard let location = await zipcodeToLocation(zip) else {
            return nil
        }
        let service = WeatherService()
        let weather = try await service.weather(for: location)
    
        return weather
      }
}


