import UIKit
import SwiftUI
import WeatherKit

struct SaddleCommandBar: View {
    @Binding var weatherSnapshot: Weather?
    @Binding var usesFahrenheit: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Color.darkBlue
                if let weatherSnapshot = weatherSnapshot {
                    HStack {
                        StackText(bigText: "\(Int(weatherSnapshot.currentWeather.apparentTemperature.converted(to: usesFahrenheit ? .fahrenheit : .celsius).value))", smallText: "Feels Like")
                            .frame(width: geo.size.width / 3)
                        StackText(bigText: "\(weatherSnapshot.currentWeather.wind.direction.description)", smallText: "Wind Direction")
                            .frame(width: geo.size.width / 3)
                        StackText(bigText: "02", smallText: "AQI")
                            .frame(width: geo.size.width / 3)
                    }
                }
            }
            Spacer()
                .frame(height: 14)
        }
    }
}
