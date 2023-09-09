//
//  Image+Design.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/8/23.
//

import Foundation
import SwiftUI

/* extension to Image.  Static properties to load each existing Image Asset by its name.  For example, to load an Image(UIImage(named: "mountains_day")), the property should be "Image.mountains_day".  The image asset names are:
 mountains_evening
 mountains_day
 mountains_cold
 forest_dark
 city_dark
 
 */

extension Image {
    
    static var sundown_neighborhood: Image {
        return Image(uiImage: UIImage(named: "sundown_neighborhood")!)
    }
    
    static var snow_car_window: Image {
        return Image(uiImage: UIImage(named: "snow_car_window")!)
    }
    
    static var rain_window: Image {
        return Image(uiImage: UIImage(named: "rain_window")!)
    }
    
    static var rain_streets: Image {
        return Image(uiImage: UIImage(named: "rain_streets")!)
    }
    
    static var forest_dark: Image {
        return Image(uiImage: UIImage(named: "forest_dark")!)
    }
    
    static var backgroundNames: [String] {
        return ["sundown_neighborhood", "snow_car_window", "rain_window", "rain_streets", "forest_dark"]
    }
    
    static func randomBackground() -> Image {
        return Image(uiImage: UIImage(named: backgroundNames.randomElement()!)!)
    }
}
