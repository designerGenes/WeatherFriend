import Foundation
import SwiftUI

struct BackboneTabView: View {
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
struct BackboneTabView_Previews: PreviewProvider {
    static var previews: some View {
        BackboneTabView(activeScreen: .main)
    }
}
#endif
