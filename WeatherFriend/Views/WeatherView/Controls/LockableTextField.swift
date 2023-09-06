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
    @State private var isLocked: Bool = false
    var checkFunction: (String) -> Bool = { value in return value.allSatisfy({$0.isNumber}) && value.count == 5 }
    var onLockFunction: () -> Void = {}
    
    var body: some View {
        HStack {
            if checkFunction(text) == true {
                HStack {
                    Spacer()
                        .frame(width:4)
                    Text(text)
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
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
                .onAppear {
                    self.onLockFunction()
                }
            } else {
                TextField("Enter Zip Code", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding()
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
