//
//  ContentView.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/8/23.
//

/**
 Build a weather app that shows the current weather and 5-day forecast for a selected city using OpenWeatherMap's API. The app should have the following features:
 
 A search field to enter a city name and fetch weather data for that city
 A view to display the current weather conditions including temperature, weather icon, description etc.
 A horizontal scrollable view to show the 5-day forecast, with each day displaying the weather icon, high/low temps, description etc.
 Use Combine to fetch the weather data asynchronously and update the UI. Define publishers, subscribers and operators to process the network request and handle errors.
 Use SwiftUI for the app's UI with views, view models and bindings to reactively update the UI when the view model changes.
 Make the UI adaptable and responsive for all device sizes using layout, frames and stacks.
 Persist the last searched city and show it first on launch.
 */


import SwiftUI
import Combine

struct DynamicBackgroundView: View {
    var body: some View {
        Image.mountains_cold
            .resizable()
    }
}

struct MainTextField: View {
    @State var colorScheme: ColorScheme
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.allowsFloats = false
        return numberFormatter
    }
    
    @Binding var textFieldValue: String
    var body: some View {
        TextField("Enter zip code", value: $textFieldValue, formatter: numberFormatter)
            .foregroundColor(Color.primary)
            .lineLimit(1)
            .keyboardType(.numberPad)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
        
            .frame(height: 44)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
    }
}

struct WeatherView: View {
    @StateObject var viewModel: WeatherViewViewModel
    @State var keyboardHeight: CGFloat = 0
    @State var trayHeight: CGFloat = 270
    @Environment(\.colorScheme) var colorScheme
    
    private func addKeyboardNotificationListeners() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            withAnimation {
                keyboardHeight = notification.keyboardHeight
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation {
                keyboardHeight = 0
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {

                if viewModel.weatherSnapshot != nil {
                    DynamicBackgroundView()
                } else {
                    LinearGradient(colors: [Color.blueGradient1, Color.blueGradient3, Color.blueGradient2], startPoint: UnitPoint(x: 0.4, y: 0), endPoint: UnitPoint(x: 0.7, y: 1))
                }
                VStack(alignment: .leading, spacing: 12) {
                    MainTextField(colorScheme: colorScheme, textFieldValue: $viewModel.zipCode)
                        .frame(width: geo.size.width * 0.95)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                
                if (viewModel.weatherAdvice != nil) {
                    VStack {
                        Spacer()
                        WeatherAdviceView(weatherAdvice: $viewModel.weatherAdvice)
                            .frame(width: geo.size.width, height: 260)
                            .opacity(0.8)
                        SaddleCommandBar(weatherSnapshot: $viewModel.weatherSnapshot, usesFahrenheit: $viewModel.usesFahrenheit)
                            .frame(width: geo.size.width, height: 100)
                        
                    }
                }
                if viewModel.weatherSnapshot != nil {
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: 80)
                        HStack {
                            CurrentTemperatureView(weatherSnapshot: viewModel.weatherSnapshot, usesFahrenheit: $viewModel.usesFahrenheit)
                                .frame(width: 150, height: 150)
                            Spacer()
                        }
                        .padding([.leading], 16)
                        Spacer()
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            addKeyboardNotificationListeners()
        }
    }
}



#if DEBUG
#Preview {
    WeatherView(viewModel: WeatherViewViewModel(usesFahrenheit: true, weatherSnapshot: MockWeatherType.mock(), weatherAdvice: MockWeatherAdvice.mock()))
}
#endif


