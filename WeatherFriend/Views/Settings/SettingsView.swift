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

struct SettingsView: View {
    
    @State private var theme = "Light"
    @State private var gptModel: OpenAIModel = .three_five
    @State private var maxTokens = 124
    @State private var customOpenAPIKey = ""
    private let apikeyRegexString = #"sk-[a-zA-Z0-9]{42}\b"#
    
    var body: some View {
        
        ZStack {
            Color.formGray.ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height: 42)
                Form {
                    Picker("Theme", selection: $theme) {
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                        Text("System").tag("System")
                    }
                    .pickerStyle(.menu)
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
    SettingsView()
}
