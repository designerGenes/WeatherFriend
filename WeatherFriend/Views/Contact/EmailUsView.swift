//
//  EmailUsView.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/21/23.
//

import SwiftUI

protocol EmailUsViewModelType: ObservableObject {
    var text: String { get set }

}

class MockEmailUsViewModel: EmailUsViewModelType {
    var text: String
    
    static func mock() -> MockEmailUsViewModel() {
        return MockEmailUsViewModel(
    }
    

}


class EmailUsViewModel: ObservableObject, EmailUsViewModelType {
    @Published var text = ""
}

struct EmailUsView<ViewModel: EmailUsViewModelType>: View {
    @StateObject var viewModel: ViewModel
    @Binding var isShowing: Bool
    
    var body: some View {
        
        ZStack {
            Color.primary
                .blur(radius: 20)
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
                            // Submit action
                        }
                        .font(.headline)
                        
                        Button("Cancel") {
                            isShowing = false
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
                
            }
            
        }
        .ignoresSafeArea()
        .sheet(isPresented: $isShowing) {
            // Show view
        }
        
    }
    
}

#Preview {
    VStack {
        EmailUsView(viewModel: MockEmailUsViewModel.mock(), isShowing: .constant(true))
    }
    .background(Color.black)
    
}
