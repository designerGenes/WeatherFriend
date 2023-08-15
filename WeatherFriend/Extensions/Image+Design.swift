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
}
