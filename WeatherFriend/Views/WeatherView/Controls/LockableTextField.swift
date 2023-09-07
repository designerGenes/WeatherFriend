//
//  LockableTextField.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/6/23.
//

import SwiftUI
import Combine

struct LockableTextField: View {
    @Binding var text: String  // Removed default value
    var checkFunction: (String) -> Bool = { value in value.allSatisfy({ $0.isNumber }) && value.count == 5 }
    var onLockFunction: (String) -> Void = { _ in }
    var onClearFunction: () -> Void = { }

    func isLocked(text: String) -> Bool {
        let isLocked = checkFunction(text)
        if isLocked {
            onLockFunction(text)
        }
        return isLocked
    }

    var body: some View {
        HStack {
            if checkFunction(text) == true {
                HStack {
                    Spacer()
                        .frame(width: 4)
                    Text(text)
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        self.text = ""  // This will now update the external state
                        onClearFunction()
                    }) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                    }
                    Spacer()
                        .frame(width: 4)
                }
                .frame(height: 42)
                .background {
                    Color.white
                        .cornerRadius(6)
                }
            } else {
                TextField("Enter Zip Code", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding()
    }
}





//
struct LockableTextField_Previews: PreviewProvider {

    var preview: some View {
        VStack(spacing: 6) {
            LockableTextField(text: .constant("12345"), checkFunction: { value in
                return value.allSatisfy({ $0.isNumber }) && value.count == 5
            }, onLockFunction: { _ in
                print("locked")
            })
            LockableTextField(text: .constant("123"), checkFunction: { value in
                return value.allSatisfy({ $0.isNumber }) && value.count == 5
            }, onLockFunction: { _ in
                print("locked")
            })
            
        }
        .background {
            Color.darkBlue
        }
    }
    
    static var previews: some View {
        LockableTextField_Previews().preview
    }
}
