import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(Color(uiColor: .primaryTextColor).opacity(0.6))
                .padding([.leading], 8)
            content()
        }
        
        .background(Color.clear)
    }
}

struct SettingsView<ViewModel: SettingsViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @State var showingEmailUs: Bool = false
    
    func NamedErrorSection(namedError: NamedError) -> some View {
        return
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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color(uiColor: .primaryTextColor))
                    .padding()
                Spacer()
            }
            
            SectionView(title: "System") {
                HStack {
                    Text("Theme")
                        .foregroundColor(Color(uiColor: .primaryTextColor))
                    
                    Spacer()
                    Picker("Theme", selection: $viewModel.colorTheme) {
                        ForEach([ColorTheme.light, .dark], id: \.self) { theme in
                            Text(theme.rawValue.capitalized).tag(theme)
                            
                        }
                    }
                    .foregroundColor(Color(uiColor: .primaryTextColor))
                    .background(Color(uiColor: .complimentaryBackgroundColor))
                    .pickerStyle(.menu)
                    .frame(minHeight: 40)
                }
                .padding([.leading, .trailing], 8)
                .background(Color(uiColor: .complimentaryBackgroundColor))
            }
            
            Spacer()
                .frame(height: 24)
                
            SectionView(title: "Other") {
                VStack(spacing: 0) {
                    Group {
                        HStack {
                            Text("About WeatherFriend")
                            Spacer()
                        }
                        HStack {
                            Text("Contact DesignerGenes")
                                .onTapGesture {
                                    self.showingEmailUs = true
                                }
                            Spacer()
                        }
                    }
                    .frame(minHeight: 40)
                    .padding([.leading, .trailing], 8)
                    .background(Color(uiColor: .complimentaryBackgroundColor))
                }
                .foregroundColor(Color(uiColor: .primaryTextColor))
                .listRowBackground(Color(uiColor: .complimentaryBackgroundColor))
                
            }
            if let namedError = viewModel.namedError {
                NamedErrorSection(namedError: namedError)
            }
            Spacer()
        }
        .background(Color(uiColor: .primaryBackgroundColor))
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
