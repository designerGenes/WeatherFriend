import UIKit
import SwiftUI
import WeatherKit

struct CurrentTemperatureView: View {
    @State var weatherSnapshot: Weather?
    @Binding var usesFahrenheit: Bool
    private var temperatureText: String {
        guard let weatherSnapshot = weatherSnapshot else {
            return "-/-"
        }
        let temp = Int(weatherSnapshot.currentWeather.temperature.converted(to: usesFahrenheit ? .fahrenheit : .celsius).value)
        return "\(String(temp))°\(usesFahrenheit ? "F" : "C")"
    }
    
    func calculateFontSize(text: String, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: CGFloat(72))
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height * font.pointSize / boundingBox.size.height
    }
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack(alignment: .center) {
                ContainerRelativeShape()
                    .foregroundColor(Color.darkBlue)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .cornerRadius(geo.size.height / 2)
                    .overlay {
                        Text(temperatureText)
                            .font(.system(size: 40, weight: .heavy, design: .monospaced))
                            .foregroundColor(Color.white)
                    }
            }
            .onTapGesture {
                usesFahrenheit.toggle()
            }
        }
    }
}
