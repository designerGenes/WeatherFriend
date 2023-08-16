import UIKit
import SwiftUI

struct WeatherAdviceView: View {
    @Binding var weatherAdvice: WeatherAdvice?
    @State var titleText: String = "Your AI Weather Advice "
    var body: some View {
        
        ZStack(alignment: .leading) {
            Color.lighterDarkBlue
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    ScrollView {
                        Spacer().frame(height: 8)
                        Text(titleText)
                            .padding(EdgeInsets(top: 4, leading: 6, bottom: 0, trailing: 0))
                            .font(.system(size: 24, weight: .heavy, design: .serif))
                            .foregroundColor(Color.white)
                            .frame(width: geo.size.width, alignment: .leading)
                        
                        Text(weatherAdvice?.advice ?? "...")
                            .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.8))
                            .frame(width: geo.size.width, alignment: .leading)
                    }
                }
                .frame(width: geo.size.width)
                
            }
            
            
        }
        .cornerRadius(8)
    }
}
