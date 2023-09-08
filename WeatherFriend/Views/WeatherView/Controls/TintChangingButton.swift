//
//  TintChangingButton.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/7/23.
//

import SwiftUI


struct TintChangingButton: View {
    var title: String? = nil
    var iconImage: Image? =  nil
    @State var isFrozen: Bool = false
    var action: (() -> Void)? = nil
    @State private var isPressed: Bool = false
    
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 2) {
                Text(title ?? "")
                    .foregroundStyle(isFrozen ? .gray : isPressed ? .clear : .black)
                if let iconImage = iconImage {
                    iconImage
                        .renderingMode(.template)
                        .foregroundColor(isFrozen ? .gray : isPressed ? .clear : .black)
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged { _ in self.isPressed = true }
                            .onEnded { _ in self.isPressed = false })
                } else {
                    Spacer()
                }
            }
            
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct TintChangingButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TintChangingButton(title: "Hi Mrs Neutron", iconImage: Image(systemName: "xmark.circle.fill"))
        }
        .background {
            Color.gray
        }
    }
    
}
