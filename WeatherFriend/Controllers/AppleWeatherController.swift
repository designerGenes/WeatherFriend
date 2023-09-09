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

final class AppleWeatherController: NSObject, AppleWeatherControllerType {

  static var sharedInstance = AppleWeatherController()
  
  private let locationManager = CLLocationManager()

  private func zipcodeToLocation(_ zipcode: String) async -> CLLocation? {
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    let geocoder = CLGeocoder()
    let addresses = try? await geocoder.geocodeAddressString(zipcode)

    guard let addresses = addresses, let location = addresses.first?.location else {
      return nil
    }

    return location

  }

  func getWeather(forZipCode zip: String) async throws -> WeatherType? {

    // Request location
    locationManager.requestLocation()

    // Handle errors
    locationManager.delegate = self

    // Wait for valid location
    guard let location = await zipcodeToLocation(zip) else {
      throw LocationError.invalidCoordinate
    }

    let service = WeatherService()

    // Only fetch weather with valid coordinate
    let weather = try await service.weather(for: location)

    return weather.currentWeather

  }

}

// Location manager delegate
extension AppleWeatherController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // Handle location error
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      switch manager.authorizationStatus {
      case .authorizedAlways:
          break
      case .notDetermined:
          break
      case .denied:
          break
      case .authorizedWhenInUse:
          break
      case .restricted:
          break
      @unknown default:
          break
      }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Use valid location coordinate
  }

}
