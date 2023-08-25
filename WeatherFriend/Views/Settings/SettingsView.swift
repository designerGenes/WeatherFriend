import SwiftUI


struct SettingsView<ViewModel: SettingsViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @State var showingEmailUs: Bool = false
    
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
            Color(uiColor: UIColor.settingsBackgroundMain)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 64)
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
                            .onTapGesture {
                                self.showingEmailUs = true
                            }
                    }
                    if let namedError = viewModel.namedError {
                        Section(header: Text("Error")) {
                            
                            
                            Text(namedError.rawValue).foregroundStyle(.secondary)
                            
                                .multilineTextAlignment(.center)
                                .padding([.leading, .trailing], 4)
                                .border(.clear, width: 1)
                                .background {
                                    Color.clear
                                }
                            HStack(spacing: 6) {
                                Spacer()
                                Button("Dismiss") {
                                    viewModel.namedError = nil
                                }
                            }
                        }
                    }
                }
                
                
            }
        }
        .sheet(isPresented: $showingEmailUs) {
            EmailUsView(viewModel: EmailUsViewModel())
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