import Foundation
import SwiftUI

struct BackboneTabView: View {
    @State var activeScreen: Screen = .main
    
    var body: some View {
        ZStack(alignment: .top) {
                switch activeScreen {
                case .main:
                    WeatherView(viewModel: WeatherViewViewModel())
                case .settings:
                    SettingsView(viewModel: SettingsViewModel())
                }
                CommandBar(selectedScreen: $activeScreen)
                    .frame(height: 30)
                    .offset(y: 56)
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
