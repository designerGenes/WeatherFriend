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
        Image.city_dark
            .resizable()
    }
}

struct MainTextField: View {
    @State var colorScheme: ColorScheme
    @Binding var textFieldValue: String
    
    var body: some View {
        TextField("Enter zip code", text: $textFieldValue)
            .foregroundColor(Color.primary)
            .lineLimit(1)
            .keyboardType(.numberPad)
            .disableAutocorrection(true)
            .frame(height: 44)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
    }
}

struct WeatherView<ViewModel: WeatherViewModelType>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if !viewModel.messages.isEmpty {
                    DynamicBackgroundView()
                } else {
                    LinearGradient(colors: [Color.blueGradient1, Color.blueGradient2, Color.blueGradient3], startPoint: .top, endPoint: .bottom)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    MainTextField(colorScheme: colorScheme, textFieldValue: $viewModel.zipCode)
                        .frame(width: geo.size.width * 0.95)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                
                if !viewModel.messages.isEmpty {
                    VStack {
                        Spacer()
                        OpenAIConversationView(messages: $viewModel.messages)
                            .frame(width: geo.size.width, height: 260)
                            .opacity(0.8)
                    }
                    VStack(alignment: .leading) {
                        Spacer().frame(height: 80)
                        HStack {
                            Spacer()
                        }.padding([.leading], 16)
                        Spacer()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}



#if DEBUG
#Preview {
    WeatherView(viewModel: MockWeatherViewModel.mock())
}
#endif


