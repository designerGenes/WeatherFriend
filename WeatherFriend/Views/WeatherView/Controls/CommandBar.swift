import UIKit
import SwiftUI

struct CommandBar: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 32) {
                ForEach(CommandButtonIcon.allCases, id: \.rawValue) { icon in
                    Image(systemName: icon.rawValue)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                }
            }
        }
    }
}
