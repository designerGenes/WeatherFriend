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

struct WeatherView<ViewModel: WeatherViewModelType>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var BackgroundGradient: some View {
        LinearGradient(colors: [Color.blueGradient1, Color.blueGradient2, Color.blueGradient3], startPoint: .top, endPoint: .bottom)
    
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                BackgroundGradient
                
                LockableTextField(text: $viewModel.zipCode,
                                  checkFunction: { value in
                    return value.allSatisfy({ $0.isNumber }) && value.count == 5
                },
                                  onLockFunction: {
                    viewModel.isShowingMessages = true
                })
                .frame(width: geo.size.width * 0.95)
                .position(x: geo.size.width / 2, y: (geo.size.height / 2) - (viewModel.isShowingMessages ? 45 : 0))
                
                
                OpenAIConversationView(messages: $viewModel.messages)
                    .opacity(0.9)
                    .frame(width: geo.size.width, height: geo.size.height / 2)
                    .position(x: geo.size.width / 2, y: viewModel.isShowingMessages ? geo.size.height * 0.75 : geo.size.height * 1.5)
                    .animation(.easeInOut, value: 0.35)
                
                
                
                
                    
            }
        }
        .ignoresSafeArea()
    }
}



#if DEBUG
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: MockWeatherViewModel.mock())
    }
}
#endif


