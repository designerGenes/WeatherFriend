//
//  SectionView.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/9/23.
//

import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(Color(uiColor: .primaryTextColor).opacity(0.6))
                .padding([.leading], 8)
            content()
        }
        
        .background(Color.clear)
    }
}

