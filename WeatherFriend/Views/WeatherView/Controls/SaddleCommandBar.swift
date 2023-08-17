import UIKit
import SwiftUI
import WeatherKit

struct SaddleCommandBar: View {
    @Binding var weatherSnapshot: WeatherType?
    @Binding var usesFahrenheit: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Color.darkBlue
                if let weatherSnapshot = weatherSnapshot {
                    HStack {
                        StackText(bigText: "\(Int(weatherSnapshot.temperature.converted(to: usesFahrenheit ? .fahrenheit : .celsius).value))", smallText: "Feels Like")
                            .frame(width: geo.size.width / 3)
                        StackText(bigText: "\(weatherSnapshot.windDirection.description)", smallText: "Wind Direction")
                            .frame(width: geo.size.width / 3)
                        StackText(bigText: "02", smallText: "AQI")
                            .frame(width: geo.size.width / 3)
                    }
                }
            }
        }
    }
}
