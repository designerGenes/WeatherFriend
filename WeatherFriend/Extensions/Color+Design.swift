//
//  Color+Design.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/8/23.
//

import Foundation
import UIKit
import SwiftUI
import CoreGraphics

// a THEME can be dark or light

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

    // VARIABLE COLORS DEPENDING ON THEME
    static var primaryBackgroundColor: UIColor {
        themedColor(colorIfLight: ColorPalette.light.primaryBackgroundColor,
                    colorIfDark: ColorPalette.dark.primaryBackgroundColor,
                    defaultColor: .systemBackground)
    }
    
    static var primaryLinkButtonColor: UIColor {
        themedColor(colorIfLight: ColorPalette.light.primaryLinkButtonColor,
                    colorIfDark: ColorPalette.dark.primaryLinkButtonColor,
                    defaultColor: .systemBlue)
    }
    
    static var complimentaryBackgroundColor: UIColor {
        themedColor(colorIfLight: ColorPalette.light.complimentaryBackground,
                    colorIfDark: ColorPalette.dark.complimentaryBackground,
                    defaultColor: .systemGray)
    }
    
    static var primaryTextColor: UIColor {
        themedColor(colorIfLight: ColorPalette.light.primaryTextColor,
                    colorIfDark: ColorPalette.dark.primaryTextColor,
                    defaultColor: .black)
    }
    
    static func themedColor(colorIfLight: UIColor, colorIfDark: UIColor, defaultColor: UIColor = .systemBackground) -> UIColor {
        // 1. if value is found in UserDefaults, go with that
        // 2. otherwise go with system
        if let themeString = UserDefaultsController.get(key: .theme, default: ColorTheme.light.rawValue), let theme = ColorTheme(rawValue: themeString) {
            switch theme {
            case .dark: return colorIfDark
            case .light: return colorIfLight
            }
        }
        return defaultColor
    }
}


// extension to Color that generates from hex string like "323843" or "#323843"
extension Color {
    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
    
    func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        let success = uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return success ? (red: red, green: green, blue: blue) : nil
    }
    
    var red: CGFloat {
        UIColor(self).ciColor.red
    }
    var green: CGFloat {
        UIColor(self).ciColor.green
    }
    
    var blue: CGFloat {
        UIColor(self).ciColor.blue
    }
}

// extension to Color to set document pallette.
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
    
}

