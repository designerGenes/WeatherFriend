//
//  MaxTokensRow.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 8/21/23.
//

import SwiftUI

struct MaxTokensRow: View {
    @Binding var maxTokens: Int
    var body: some View {
        HStack {
            Text("Max Tokens")
            TextField("\(maxTokens)", text: Binding(
                get: {
                    "\(maxTokens)"
                },
                set: { newValue in
                    maxTokens = Int(newValue) ?? maxTokens
                }
            ))
            .keyboardType(.numberPad)
        }
    }
}
