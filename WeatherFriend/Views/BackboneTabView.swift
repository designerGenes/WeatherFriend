import Foundation
import SwiftUI

struct BackboneTabView: View {
    var body: some View {
        ZStack(alignment: .top) {
            TabView {
                WeatherView()
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
