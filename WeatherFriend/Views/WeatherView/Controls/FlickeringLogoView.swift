//
//  FlickeringLogoView.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/9/23.
//

import SwiftUI

struct FlickeringLogoView: View {
    @State private var opacity: Double = 1.0
    @State var text: String
    @State var foregroundColor: Color
    @State var font: Font
    

    var body: some View {
        Text(text)
            .foregroundStyle(foregroundColor)
            .font(font)
            .opacity(opacity)
            .onAppear {
                self.flickerAnimation()
            }
    }

    func randomInterval() -> Double {
        return Double.random(in: 0.5...1.5)
    }

    func flickerAnimation() {
        let newOpacity = Double.random(in: 0...1)
        let duration = randomInterval()

        withAnimation(Animation.linear(duration: duration).repeatCount(1, autoreverses: false)) {
            self.opacity = newOpacity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.flickerAnimation()
        }
    }
}

#if DEBUG
struct FlickeringLogoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FlickeringLogoView(text: "WeatherFriend",
                               foregroundColor: Color(uiColor: .complimentaryBackgroundColor),
                               font: Font.custom("Sacramento-Regular", size: 40))
        }
        .background(Color.gray)
    }
}
#endif
