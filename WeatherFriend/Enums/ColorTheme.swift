//
//  ColorTheme.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/20/23.
//

import Foundation
import UIKit

/**
 A color palette is a collection of related colors, based on a theme
 */
class ColorPalette: ObservableObject {
    @Published var primaryBackgroundColor: UIColor  // background of large bodies
    @Published var primaryTextColor: UIColor // foreground color of text on complimentary
    @Published var complimentaryBackground: UIColor // row color set against primary background
    @Published var primaryLinkButtonColor: UIColor // color of links and button text
    
    init(primaryBackgroundColor: UIColor, primaryTextColor: UIColor, complimentaryBackground: UIColor, primaryLinkButtonColor: UIColor) {
        self.primaryBackgroundColor = primaryBackgroundColor
        self.primaryTextColor = primaryTextColor
        self.complimentaryBackground = complimentaryBackground
        self.primaryLinkButtonColor = primaryLinkButtonColor
    }
}

extension ColorPalette {
    static var light: ColorPalette {
        ColorPalette(primaryBackgroundColor: UIColor(hex: "F2F2F7"),
                     primaryTextColor: UIColor(hex: "0F0F0F"),
                     complimentaryBackground: UIColor(hex: "FFFFFF"),
                     primaryLinkButtonColor: UIColor(hex: "4489F7"))
    }
    
    static var dark: ColorPalette {
        ColorPalette(primaryBackgroundColor: UIColor(hex: "000000"),
                     primaryTextColor: UIColor(hex: "F9F9F9"),
                     complimentaryBackground: UIColor(hex: "1C1C1E"),
                     primaryLinkButtonColor: UIColor(hex: "4489F7"))
    }
    
    
}

/**
 A color theme is what delineates palettes from each other, based on a role
 */
enum ColorTheme: String, CaseIterable {
    case light, dark
    
    var palette: ColorPalette {
        switch self {
        case .light: return ColorPalette.light
        case .dark: return ColorPalette.dark
        }
    }
}
