import SwiftUI


struct MaxTokensRow: View {
    @Binding var maxTokens: Int
    var body: some View {
        HStack {
            Text("Max Tokens")
            TextField("\(maxTokens)", text: Binding(
                get: {
                    "\(maxTokens)"
                },
                set: { newValue in
                    maxTokens = Int(newValue) ?? maxTokens
                }
            ))
            .keyboardType(.numberPad)
        }
    }
}

protocol SettingsViewModelType: ObservableObject {
    var theme: ColorTheme { get set }
    var gptModel: OpenAIModel { get set }
    var maxTokens: Int { get set }
    var customOpenAPIKey: String { get set }
}

class MockSettingsViewModel: ObservableObject, SettingsViewModelType {
    @Published var theme: ColorTheme = .system
    @Published var gptModel: OpenAIModel = .three_five
    @Published var maxTokens = 124
    @Published var customOpenAPIKey = ""
    
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
    let apikeyRegexString = #"sk-[a-zA-Z0-9]{42}\b"#
}

struct SettingsView<ViewModel: SettingsViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        viewModel.theme = UserDefaultsController.get(key: .theme, default: .system) {
            ColorTheme(rawValue: $0 as! String)!
        } ?? .system
        
        viewModel.gptModel = UserDefaultsController.get(key: .gptModel, default: .three_five) {
            OpenAIModel(rawValue: $0 as! String)!
        } ?? .three_five
        
        viewModel.maxTokens = UserDefaultsController.get(key: .gptMaxTokens, default: 124) {
            $0 as! Int
        } ?? 124
        
        viewModel.customOpenAPIKey = KeychainController.get(key: .openAPIKey) ?? ""
    }
    
    var body: some View {
        ZStack {
            Color.formGray.ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height: 42)
                Form {
                    Picker("Theme", selection: $viewModel.theme) {
                        Text(ColorTheme.light.rawValue.capitalized).tag(ColorTheme.light.rawValue)
                        Text(ColorTheme.dark.rawValue.capitalized).tag(ColorTheme.dark.rawValue)
                        Text(ColorTheme.system.rawValue.capitalized).tag(ColorTheme.system.rawValue)
                    }
                    .onChange(of: viewModel.theme) { newValue in
                        
                        viewModel.theme = newValue
                        UserDefaultsController.set(key: .theme, value: newValue.rawValue)
                    }
                    .pickerStyle(.menu)
                    
                    Section(header: Text("App")) {
                        Text("About WeatherFriend")
                        Text("Contact DesignerGenes")
                    }
                }
            }
        }
    }
}
#Preview {
    SettingsView<MockSettingsViewModel>(viewModel: MockSettingsViewModel.mock())
}

// for later...
//                    Section("API") {
//
//                        if customOpenAPIKey ~= apikeyRegexString {
//
//                            TextField("API Key", text: $customOpenAPIKey)
//                                .autocapitalization(.none)
//                                .disableAutocorrection(true)
//
//                            MaxTokensRow(maxTokens: $maxTokens)
//                            Picker("Model", selection: $gptModel) {
//                                Text(OpenAIModel.three_five.rawValue).tag(OpenAIModel.three_five)
//                                Text(OpenAIModel.four.rawValue).tag(OpenAIModel.four)
//                                Text(OpenAIModel.three_five_turbo.rawValue).tag(OpenAIModel.three_five_turbo)
//                            }
//                            .pickerStyle(.menu)
//
//                        } else {
//
//                            HStack {
//                                TextField("API Key", text: $customOpenAPIKey)
//                                Button("Submit") {
//
//                                }
//                            }
//
//                        }
//                    }
