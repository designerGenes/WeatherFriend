import Foundation
import SwiftUI

struct BackboneTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var activeScreen: Screen = .main
    
    var body: some View {
        ZStack(alignment: .top) {
                switch activeScreen {
                case .main:
                    WeatherView(viewModel: MockWeatherViewModel.mock())
                case .settings:
                    SettingsView(viewModel: MockSettingsViewModel.mock())
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
