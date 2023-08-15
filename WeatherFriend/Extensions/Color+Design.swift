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
}

