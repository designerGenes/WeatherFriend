//
//  LocationError.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/9/23.
//

import Foundation

enum LocationError: Error {
  case invalidCoordinate
  case requestFailed(Error)
  case unauthorized
}
