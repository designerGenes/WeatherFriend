//
//  LockableTextField.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/6/23.
//

import SwiftUI
import Combine

struct LockableTextField: View {
    @Binding var text: String
    @State var internalText: String = ""
    @State var isLocked: Bool = false
    var textSubject = CurrentValueSubject<String, Never>("")
    @State var cancellable: AnyCancellable?
    
    var checkFunction: (String) -> Bool = { value in
        return value.allSatisfy({ $0.isNumber }) && value.count == 5
    }
    
    var onLockFunction: () -> Void = {}
    
    var body: some View {
        HStack {
            if isLocked {
                HStack {
                    Spacer()
                        .frame(width:4)
                    Text(internalText)
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        self.isLocked = false
                        self.internalText = ""
                        self.text = ""  // Update external binding
                    }) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                    }
                    Spacer()
                        .frame(width: 4)
                }
                .frame(height: 42)
                .background {
                    Color.lightGray
                        .cornerRadius(6)
                }
                
            } else {
                TextField("Enter Zip Code", text: $internalText)
                    
                    .frame(height: 42)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: internalText) { newValue in
                        text = newValue  // Update external binding
                        textSubject.send(newValue)  // Send new value to our subject
                    }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        
        .onAppear {
            self.internalText = self.text  // Initialize internal state from external binding
            
            self.cancellable = textSubject
                .sink { newValue in
                    if self.checkFunction(newValue) {
                        self.isLocked = true
                        self.onLockFunction()
                    }
                }
        }
        .onDisappear {
            self.cancellable?.cancel()
        }
    }
}



struct LockableTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 6) {
            LockableTextField(text: .constant("12345"), checkFunction: { value in
                return value.allSatisfy({ $0.isNumber }) && value.count == 5
            }, onLockFunction: {
                print("locked")
            })
            LockableTextField(text: .constant("123"), checkFunction: { value in
                return value.allSatisfy({ $0.isNumber }) && value.count == 5
            }, onLockFunction: {
                print("locked")
            })
            
        }
        .background {
            Color.darkBlue
        }
    }
}
