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
    
    var FillImage: Image {
        let currentTimestamp = Date().timeIntervalSince1970
        let savedTimestamp = UserDefaults.standard.double(forKey: UserDefaultsKey.backgroundLastChangedTimestamp.rawValue)
        
        // if no timestamp saved OR timestamp is past threshold
        if savedTimestamp <= 0 || currentTimestamp - savedTimestamp > 1000 * 60 * 5 {
            // will only happen if timestamp is past threshold
            UserDefaults.standard.set(Image.backgroundNames.randomElement(), forKey: UserDefaultsKey.backgroundLastImageName.rawValue)
            UserDefaults.standard.set(currentTimestamp, forKey: UserDefaultsKey.backgroundLastChangedTimestamp.rawValue)
        }
        let savedImageName = UserDefaults.standard.string(forKey: UserDefaultsKey.backgroundLastImageName.rawValue)
        return Image(uiImage: UIImage(named: savedImageName!)!)
    }
    
    var BackgroundGradient: some View {
        ZStack {
            FillImage
                .resizable()
                .scaledToFill()
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [Color.darkBlue, Color.lighterDarkBlue]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.2)
            )
            VStack {
                Spacer()
                    .frame(height: 64)
                FlickeringLogoView(text: "WeatherFriend",
                                   foregroundColor: Color(uiColor: .white),
                                   font: Font.custom("Sacramento-Regular", size: 48))
                Spacer()
            }
                
        }
        .ignoresSafeArea()
        .frame(maxWidth: UIScreen.main.bounds.width)
    }
    
    var WeatherSpeedometersView: some View {
        HStack(alignment: .top, spacing: 24) {
            Spacer()
            if let weather = viewModel.weather {
                CircularSpeedometerView(title: "Temp",
                                        value: weather.temperature.value,
                                        maxValue: viewModel.usesFahrenheit ? Double(130) : Double(130).toCelsius,
                                        threshold: viewModel.usesFahrenheit ? Double(100) : Double(100).toCelsius,
                                        unit: viewModel.usesFahrenheit ? .fahrenheit : .celsius,
                                        color: .blue,
                                        maxValueColor: .red)
                .frame(width: 96, height: 96)
                
                CircularSpeedometerView(title: "Wind",
                                        value: weather.windSpeed.value,
                                        maxValue: 100,
                                        threshold: 20,
                                        unit: .milesPerHour,
                                        color: .green,
                                        maxValueColor: .orange)
                .frame(width: 96, height: 96)
                
                CircularSpeedometerView(title: "Humidity",
                                        value: weather.humidity,
                                        maxValue: 1,
                                        threshold: 0.5,
                                        unit: .percent,
                                        color: .darkBlue,
                                        maxValueColor: .lighterDarkBlue)
                .frame(width: 96, height: 96)
            } else {
                Text("")
            }
            Spacer()
        }
            .padding([.leading, .trailing], 24)
            .padding([.top], 10)
            .frame(height: 80)
            .background(Color(uiColor: .primaryBackgroundColor).opacity(0.9))
    }
        
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geo in
                BackgroundGradient
                    
                VStack(alignment: .center) {
                    Spacer()
                    LockableTextField(text: $viewModel.zipCode,
                                      checkFunction: { value in
                        return value.allSatisfy({ $0.isNumber }) && value.count == 5
                    },
                                      onLockFunction: { zipCode in
                        //
                    }, onClearFunction: {
                        Task {
                            await self.viewModel.reset()
                        }
                    })
                    .frame(width: geo.size.width * 0.95)

                    if viewModel.weather != nil {
                        WeatherSpeedometersView
                    }
                    if viewModel.isShowingMessages && !viewModel.messages.isEmpty {
                    
                        OpenAIConversationView(delegate: viewModel, isShowingConversationCommands: $viewModel.isShowingConversationCommands, loadingProgress: $viewModel.loadingProgress, messages: $viewModel.messages)
                            .opacity(0.9)
                            .frame(width: geo.size.width, height: geo.size.height / 2)
                        .animation(.easeInOut, value: 0.35)
                        
                    }
                }
                .padding([.bottom], 32)
                .frame(width: geo.size.width)
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


