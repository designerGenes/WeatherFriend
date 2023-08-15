import UIKit
import SwiftUI

struct SaddleCommandBar: View {
    @Binding var weatherMoment: WeatherMoment?
    @Binding var usesFahrenheit: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Color.darkBlue
                if let weatherMoment = weatherMoment {
                    HStack {
                        StackText(bigText: "\(Int(usesFahrenheit ? weatherMoment.current.feelslikeF : weatherMoment.current.feelslikeC))", smallText: "Feels Like")
                            .frame(width: geo.size.width / 3)
                        StackText(bigText: "\(weatherMoment.current.windDir)", smallText: "Wind Direction")
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
