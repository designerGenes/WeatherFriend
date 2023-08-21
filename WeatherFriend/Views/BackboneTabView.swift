import Foundation
import SwiftUI

struct BackboneTabView: View {
    @Environment(\.colorScheme) var colorScheme
    
    
    @State var activeScreen: Screen = .main
    var body: some View {
        ZStack(alignment: .top) {
//            TabView {
                switch activeScreen {
                case .main:
                    WeatherView(viewModel: WeatherViewViewModel(usesFahrenheit: true, weatherSnapshot: MockWeatherType.mock()))
                case .settings:
                    SettingsView()
                }
                CommandBar(selectedScreen: $activeScreen)
                    .frame(height: 30)
                .padding()
        }
    }
}


#if DEBUG
#Preview {
    BackboneTabView(activeScreen: .main)
}
#endif
