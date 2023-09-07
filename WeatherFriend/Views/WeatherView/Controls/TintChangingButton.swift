//
//  TintChangingButton.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/7/23.
//

import SwiftUI


struct TintChangingButton: View {
    @State private var isPressed = false
    var iconImage: Image? =  nil
    var title: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 2) {
                Text(title ?? "")
                    .foregroundStyle(isPressed ? .gray : .white)
                if let iconImage = iconImage {
                    iconImage
                        .renderingMode(.template)
                        .foregroundColor(isPressed ? .gray : .white)
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

struct TintChangingButton_Preivews: PreviewProvider {
    static var previews: some View {
        VStack {
            TintChangingButton(title: "Hi Mrs Neutron")
        }
        .background {
            Color.black
        }
    }
    
}
