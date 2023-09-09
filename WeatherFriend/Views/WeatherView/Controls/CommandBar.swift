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
                        .shadow(radius: 5)
                })
                .buttonStyle(.borderless)
                .frame(width: 32, height: 32)
                .foregroundColor(Color(uiColor: .primaryTextColor))
            }
        }
        .padding([.leading, .trailing], 32)
        .padding([.top, .bottom], 8)
    }
}


#if DEBUG
struct CommandBar_Previews: PreviewProvider {
    static var previews: some View {
        CommandBar(selectedScreen: .constant(.main))
            .background(Color(uiColor: .complimentaryBackgroundColor))
    }
}
#endif
