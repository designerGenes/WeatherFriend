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

    static var mountains_evening: Image {
        return Image(uiImage: UIImage(named: "mountains_evening")!)
    }
    
    static var mountains_day: Image {
        return Image(uiImage: UIImage(named: "mountains_day")!)
    }
    
    static var mountains_cold: Image {
        return Image(uiImage: UIImage(named: "mountains_cold")!)
    }
    
    static var forest_dark: Image {
        return Image(uiImage: UIImage(named: "forest_dark")!)
    }
    
    static var city_dark: Image {
        return Image(uiImage: UIImage(named: "city_dark")!)
    }
    
    /* static variables for images with these asset names: sundown_neighborhood, snow_sunny, snow_streets, snow_car_window, rain_window, rain_streets, mountains_evening, city_dark */
    static var sundown_neighborhood: Image {
        return Image(uiImage: UIImage(named: "sundown_neighborhood")!)
    }
    
    static var snow_sunny: Image {
        return Image(uiImage: UIImage(named: "snow_sunny")!)
    }
    
    static var snow_streets: Image {
        return Image(uiImage: UIImage(named: "snow_streets")!)
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
    
    
    
    
    
    
    
}
