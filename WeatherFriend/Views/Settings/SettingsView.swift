import SwiftUI


struct SettingsView<ViewModel: SettingsViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var keyboardObserver = KeyboardObserver()
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
            Color(uiColor: UIColor.complimentaryBackgroundColor)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 64)
                Form {
                    Picker("Theme", selection: $viewModel.theme) {
                        ForEach([ColorTheme.light, .dark, .system], id: \.self) { theme in
                            Text(theme.rawValue.capitalized).tag(theme)
                        }
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
        .overlay {
            if showingEmailUs {
                EmailUsView(viewModel: EmailUsViewModel(), isShowing: $showingEmailUs)
            }
            
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}


#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView<MockSettingsViewModel>(viewModel: MockSettingsViewModel.mock())
    }
}
#endif
