//
//  KeyboardObserver.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/3/23.
//

import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = rect.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
    }
}

