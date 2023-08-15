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


struct WeatherView: View {
    @StateObject var viewModel: WeatherViewViewModel = WeatherViewViewModel()
    @State var keyboardHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                Image.city_dark
                    .resizable()
                
                
                VStack(alignment: .center, spacing: 12) {
                    Spacer()
                        .frame(height: 30)
                    CommandBar()
                        .frame(height: 30)
                        .padding()
                    if viewModel.weatherMoment != nil {
                        HStack {
                            CurrentTemperatureView(weatherMoment: viewModel.weatherMoment, usesFahrenheit: $viewModel.usesFahrenheit)
                                .frame(width: 150, height: 150)
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    TextField("Enter zip code", text: $viewModel.zipCode)
                        .lineLimit(1)
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .frame(width: geo.size.width * 0.9, height: 16)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .offset(y: viewModel.weatherMoment == nil ? -keyboardHeight : 0)
                        .animation(.easeOut, value: 0.25)
                        
                    
                    if viewModel.weatherMoment == nil {
                        Spacer()
                            .frame(height: 24)
                    } else {
                        if viewModel.weatherAdvice != nil {
                            WeatherAdviceView(weatherAdvice: $viewModel.weatherAdvice)
                                .frame(width: geo.size.width, height: 160)
                        }
                        SaddleCommandBar(weatherMoment: $viewModel.weatherMoment, usesFahrenheit: $viewModel.usesFahrenheit)
                            .frame(width: geo.size.width, height: 100)
                        
                    }
                    
                }
                .onAppear {
                    // Register to receive notification
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
            }
            .gesture(TapGesture().onEnded({ _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }))
            .ignoresSafeArea()
        }
        
        
    }
}



#if DEBUG
#Preview {
    WeatherView()
}
#endif


