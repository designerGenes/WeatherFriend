//
//  Color+Design.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/8/23.
//

import Foundation
import UIKit
import SwiftUI

// extension to UIColor that generate from hex string like "323843" or "#323843"

extension UIColor {
    convenience init(hex: String) {
        var hex = hex
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    static var formBackgroundLight: UIColor {
        UIColor(hex: "F2F2F7")
    }
    
    static var darkModeBackground: UIColor {
        UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
    }
    
    static var backgroundMain: UIColor {
        guard let theme = UserDefaultsController.get(key: .theme, default: .system, conversionFunction: { rawTheme in
            ColorTheme(rawValue: rawTheme as! String) ?? .system
        }) else {
            return UIColor.systemBackground
        }
        switch theme {
        case .dark: return UIColor.darkModeBackground
        case .light: return UIColor.white
        case .system: return UIColor.systemBackground
        }
    }
    
    static var settingsBackgroundMain: UIColor {
        guard let theme = UserDefaultsController.get(key: .theme, default: .system, conversionFunction: { rawTheme in
            ColorTheme(rawValue: rawTheme as! String) ?? .system
        }) else {
            return UIColor.systemBackground
        }
        switch theme {
        case .dark: return UIColor.darkModeBackground
        case .light: return UIColor.formBackgroundLight
        case .system: return UIColor.systemBackground
        }
    }
    
//    static var textMain: UIColor {
//        guard let theme = UserDefaultsController.get(key: .theme, default: .system, conversionFunction: { rawTheme in
//            ColorTheme(rawValue: rawTheme as! String) ?? .system
//        }) else {
//            return Color.label
//        }
//        switch theme {
//        case .dark: return UIColor.white
//        case .light: return UIColor.black
//        case .system: return UIColor.systemBackground
//        
//        }
//    }
}


// extension to Color that generates from hex string like "323843" or "#323843"
extension Color {
    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
}

// extension to Color to set document pallette.  Three static properties which return Colors that have hex values of 323843, ECA800, and F6F9FA
extension Color {
    static var darkBlue: Color {
        return Color(hex: "323843")
    }
    
    static var lightOrange: Color {
        return Color(hex: "ECA800")
    }
    
    static var lightGray: Color {
        return Color(hex: "F6F9FA")
    }
    
    static var lighterDarkBlue: Color {
        return Color(hex: "525E74")
    }
    
    static var blueGradient1: Color {
        return Color(hex: "13192A")
    }
    
    static var blueGradient2: Color {
        return Color(hex: "0D1426")
    }
    
    static var blueGradient3: Color {
        return Color(hex: "1A1F2E")
    }
    
    static var formGray: Color {
        return Color(uiColor: UIColor.formBackgroundLight)
    }
    
}

