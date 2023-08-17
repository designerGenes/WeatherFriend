import Foundation
import SwiftUI

struct BackboneTabView: View {
    var body: some View {
        ZStack(alignment: .top) {
            TabView {
                WeatherView(viewModel: WeatherViewViewModel(usesFahrenheit: true, weatherSnapshot: MockWeatherType.mock()))
            }
            CommandBar()
                .frame(height: 30)
                .padding()
        }
    }
}


#if DEBUG
#Preview {
    BackboneTabView()
}
#endif
