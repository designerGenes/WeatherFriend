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
    var theme: ColorTheme { get set }
    var gptModel: OpenAIModel { get set }
    var maxTokens: Int { get set }
    var customOpenAPIKey: String { get set }
    var namedError: NamedError? { get set }
}

class MockSettingsViewModel: ObservableObject, SettingsViewModelType {
    @Published var theme: ColorTheme = .system {
        didSet {
            UserDefaultsController.set(key: .theme, value: theme.rawValue)
        }
    }
    @Published var gptModel: OpenAIModel = .three_five
    @Published var maxTokens = 124
    @Published var customOpenAPIKey = ""
    @Published var namedError: NamedError? = nil
    
    static func mock() -> MockSettingsViewModel {
        let viewModel = MockSettingsViewModel()
        viewModel.theme = .system
        viewModel.gptModel = .three_five
        viewModel.maxTokens = 124
        viewModel.customOpenAPIKey = ""
        return viewModel
    }
    
}





class SettingsViewModel: ObservableObject, SettingsViewModelType {
    @Published var theme: ColorTheme = .system
    @Published var gptModel: OpenAIModel = .three_five
    @Published var maxTokens = 124
    @Published var customOpenAPIKey = ""
    @Published var namedError: NamedError? = nil
    let apikeyRegexString = #"sk-[a-zA-Z0-9]{42}\b"#
}
