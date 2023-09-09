//
//  SettingsViewModel.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/21/23.
//

import Foundation
import UIKit
import SwiftUI

protocol SettingsViewModelType: ObservableObject {
    var colorTheme: ColorTheme { get set }
    var gptModel: OpenAIModel { get set }
    var maxTokens: Int { get set }
    var customOpenAPIKey: String { get set }
    var namedError: NamedError? { get set }
}

class MockSettingsViewModel: ObservableObject, SettingsViewModelType {
    @Published var colorTheme: ColorTheme = .light {
        willSet {
            UserDefaultsController.set(key: .theme, value: newValue.rawValue)
        }
    }
    @Published var gptModel: OpenAIModel = .three_five
    @Published var maxTokens = 124
    @Published var customOpenAPIKey = ""
    @Published var namedError: NamedError? = nil
    
    static func mock() -> MockSettingsViewModel {
        var mockColorTheme: ColorTheme = .light
        let savedColorThemeString: String? = UserDefaultsController.get(key: .theme)
        if let savedColorThemeString = savedColorThemeString, let colorTheme = ColorTheme(rawValue: savedColorThemeString) {
            mockColorTheme = colorTheme
        }
        var out = MockSettingsViewModel()
        out.colorTheme = mockColorTheme
        return out
    }
    
    init() {
        if let savedGptModelString: String = UserDefaultsController.get(key: .gptModel, default: OpenAIModel.three_five.rawValue),
           let gptModel = OpenAIModel(rawValue: savedGptModelString) {
            self.gptModel = gptModel
        }
    }
}

class SettingsViewModel: ObservableObject, SettingsViewModelType {
    @Published var colorTheme: ColorTheme = .light {
        willSet {
            UserDefaultsController.set(key: .theme, value: newValue.rawValue)
        }
    }

    @Published var gptModel: OpenAIModel = .three_five
    @Published var maxTokens = 124
    @Published var customOpenAPIKey = ""
    @Published var namedError: NamedError? = nil
    
    init() {
        
        
        if let savedGptModelString: String = UserDefaultsController.get(key: .gptModel, default: OpenAIModel.three_five.rawValue),
           let gptModel = OpenAIModel(rawValue: savedGptModelString) {
            self.gptModel = gptModel
        }
        
        if let savedMaxTokens: Int = UserDefaultsController.get(key: .gptMaxTokens, default: 124) {
            self.maxTokens = savedMaxTokens
        }
        
        if let savedCustomOpenAPIKey: String = KeychainController.get(key: .openAPIKey) {
            self.customOpenAPIKey = savedCustomOpenAPIKey
        }
        

        let savedColorThemeString: String? = UserDefaultsController.get(key: .theme)
        if let savedColorThemeString = savedColorThemeString, let colorTheme = ColorTheme(rawValue: savedColorThemeString) {
            self.colorTheme = colorTheme
        }
    }
}
