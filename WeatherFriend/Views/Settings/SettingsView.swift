import SwiftUI



struct SettingsView<ViewModel: SettingsViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @State var showingEmailUs: Bool = false
    @State var showingAboutApp: Bool = false
    
    func AboutUsSection() -> some View {
        return VStack(alignment: .leading) {
            Spacer()
                .frame(height:42)
            Group {
                Text("About WeatherFriend").font(.headline)
                Text("Hey there! WeatherFriend is your go-to buddy for making the most out of any weather. Just pop in your zip code and let us suggest fun activities, cool places to visit, and even what to wear. We're here to add a little sunshine (or warm rain) to your day!").font(.body)
            }
            .padding([.leading, .trailing], 8)
            .foregroundStyle(Color(uiColor: .primaryTextColor))
            Spacer()
                .frame(height:42)
        }
        .background(Color(uiColor: .complimentaryBackgroundColor))
    }
    
    func NamedErrorSection(namedError: NamedError) -> some View {
        return
        VStack {
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
        .background(Color(uiColor: .primaryBackgroundColor))
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
            Spacer()
                .frame(height: 64)
            SectionView(title: "System") {
                VStack {
                    Group {
                        HStack {
                            Text("Theme")
                                .foregroundStyle(Color(uiColor: .primaryTextColor))
                            Spacer()
                            Picker("Theme", selection: $viewModel.colorTheme) {
                                ForEach([ColorTheme.light, .dark], id: \.self) { theme in
                                    Text(theme.rawValue.capitalized).tag(theme)
                                    
                                }
                            }
                            
                        }
                                                
                        HStack {
                            Text("API Key")
                                .foregroundStyle(Color(uiColor: .primaryTextColor))
                            Spacer()
                            Text("Coming soon")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    .padding([.leading, .trailing], 8)
                    .frame(minHeight: 40)
                    .foregroundColor(Color(uiColor: .primaryTextColor))
                    .background(Color(uiColor: .complimentaryBackgroundColor))
                    .pickerStyle(.menu)
                    
                    
                }
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
                        .onTapGesture {
                            self.showingAboutApp.toggle()
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
            } else if showingAboutApp {
                AboutUsSection()
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
