//
//  EmailUsView.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/21/23.
//

import SwiftUI
import Combine

struct EmailUsView<ViewModel: EmailUsViewModelType>: View {
    @StateObject var viewModel: ViewModel
    @Binding var isShowing: Bool
    @Environment(\.dismiss) var dismiss
    @ObservedObject var keyboardObserver = KeyboardObserver()
    
    var BlurredBackground: some View {
        Color.gray
            .blur(radius: 20)
            .animation(.easeInOut, value: 0.25)
            .ignoresSafeArea()
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
    
    var ControlRow: some View {
        HStack {
            Spacer()
            
            Button("Submit") {
                viewModel.sendEmail()
                isShowing = false
            }
            .font(.headline)
            
            Button("Cancel") {
                isShowing = false
            }
            .font(.headline)
            
        }
        .padding()
        .cornerRadius(10)
        .foregroundColor(.white)
    }
    
    var body: some View {
        
        ZStack {
            BlurredBackground
            VStack(spacing: 20) {
                TextEditor(text: $viewModel.text)
                    .foregroundColor(.primary)
                    .font(.body)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                
                
                ControlRow
            }
            
            .background(Color.primary)
            .cornerRadius(10)
            .frame(maxHeight: UIScreen.main.bounds.height / 2)
            .offset(y: -keyboardObserver.keyboardHeight)
            .animation(.easeInOut, value: keyboardObserver.keyboardHeight)
            
        }
        
        .ignoresSafeArea()
        .onReceive(viewModel.objectWillChange) { _ in
            if !isShowing || viewModel.namedError != nil {
                dismiss()
            }
        }
    }
}


#if DEBUG
struct EmailUsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EmailUsView(viewModel: MockEmailUsViewModel(namedError: .settings_email_error, isShowing: true, text: "This is a test email"), isShowing: .constant(true))
        }
        .background(Color.black)
    }
    
}
#endif
