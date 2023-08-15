import UIKit
import SwiftUI

struct StackText: View {
    @State var bigText: String = "00"
    @State var smallText: String = "abde"
    @State var showEllipsis: Bool = true
    var body: some View {
        VStack(alignment: .center) {
            if showEllipsis {
                Text("...")
                    .frame(width: 32, height: 16)
                    .foregroundColor(Color.lightOrange)
            }
            Text(bigText)
                .font(.system(size: 28, weight: .heavy, design: .serif))
                .foregroundColor(Color.white)
            Text(smallText)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundColor(Color.white.opacity(0.8))
            
        }
    }
}
