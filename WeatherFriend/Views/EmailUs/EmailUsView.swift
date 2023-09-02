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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        ZStack {
            Color.gray
                .blur(radius: 20)
                .animation(.easeInOut, value: 0.25)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    TextEditor(text: $viewModel.text)
                        .foregroundColor(.primary)
                        .font(.body)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    HStack {
                        Spacer()
                        
                        Button("Submit") {
                            viewModel.sendEmail()
                        }
                        .font(.headline)
                        
                        Button("Cancel") {
                            viewModel.isShowing = false
                        }
                        .font(.headline)
                        
                    }
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    
                }
                .padding()
                .background(Color.primary)
                .cornerRadius(10)
                .frame(maxHeight: UIScreen.main.bounds.height / 2)
                
                Spacer()
            }
            .padding()
            
        }
        .ignoresSafeArea()
        .onReceive(viewModel.objectWillChange) { _ in
            if !viewModel.isShowing {
                dismiss()
            }
            if viewModel.namedError != nil {
                dismiss()
            }
        }
    }
}


#if DEBUG
struct EmailUsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EmailUsView(viewModel: MockEmailUsViewModel(namedError: .settings_email_error, isShowing: true, text: "This is a test email"))
        }
        .background(Color.black)
    }
    
}
#endif
