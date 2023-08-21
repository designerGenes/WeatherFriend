import UIKit
import SwiftUI

struct CommandBar: View {
    @Binding var selectedScreen: Screen
    
    var body: some View {
        HStack(spacing: 32) {
            Spacer()
            ForEach(CommandButtonIcon.allCases, id: \.rawValue) { icon in
                Button(action: {
                    selectedScreen = icon.matchingScreen
                    print(selectedScreen.rawValue)
                }, label: {
                    Image(systemName: icon.rawValue)
                        .resizable()
                })
                .buttonStyle(.borderless)
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
            }
        }
        .padding([.leading, .trailing], 32)
        .padding([.top, .bottom], 8)
    }
}


#if DEBUG
#Preview {
    CommandBar(selectedScreen: .constant(.main))
        .background(Color.black)
}
#endif
