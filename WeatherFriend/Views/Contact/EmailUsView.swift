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
                    //                        .focused($isShowing)
                    
                    HStack {
                        Spacer()
                        Button("Submit") {
                            viewModel.sendEmail()
                                .sink { completion in
                                    
                                } receiveValue: { _ in
                                    //
                                }

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
    }
}

#Preview {
    VStack {
        EmailUsView(viewModel: MockEmailUsViewModel.mock())
    }
    .background(Color.black)
    
}
