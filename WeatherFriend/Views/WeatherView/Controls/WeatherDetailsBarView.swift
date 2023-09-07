//
//  WeatherDetailsBarView.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/7/23.
//

import SwiftUI
import WeatherKit
import CoreImage



struct WeatherIconView: View {
    var imageName: String
    var title: String = ""
    var shadowColor: Color = .blue
    @State private var showTitle: Bool = false
    
    var body: some View {
        
        VStack(spacing: 10) {
            if showTitle {
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .fontWeight(.bold)
            } else {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: shadowColor, radius: 2, x: 2, y: 2)
                    .frame(width: 50, height: 50)
            }
            
        }
        .gesture(DragGesture(minimumDistance: 0)
            .onChanged({ _ in
                self.showTitle = true
            })
                .onEnded({ _ in
                    self.showTitle = false
                })
        )
        
    }
}

extension WeatherIconView {
    static var raining: WeatherIconView {
        WeatherIconView(imageName: "cloud.rain.fill", title: "Raining", shadowColor: .blue)
    }
    
    static var sunny: WeatherIconView {
        WeatherIconView(imageName: "sun.max", title: "Sunny", shadowColor: .yellow)
    }
    
    static var windy: WeatherIconView {
        WeatherIconView(imageName: "wind", title: "Windy", shadowColor: .gray)
    }
}


struct WeatherDetailsBarView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            CircularSpeedometerView(title: "Temp", value: 100, maxValue: 130, threshold: 100, unit: .celsius, color: .blue, maxValueColor: .red)
                .frame(width: 96, height: 96)
            
            CircularSpeedometerView(title: "AQI", value: 61, maxValue: 100, threshold: 60, unit: .percent, color: .green, maxValueColor: .orange)
                .frame(width: 96, height: 96)
            
            WeatherIconView.raining
                .frame(width: 96, height: 96)
        }
        .padding([.leading, .trailing], 24)
        .frame(height: 144)
        
        .background {
            Color.formGray
        }
    }
}

struct WeatherDetailsBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WeatherDetailsBarView()
        }
        .frame(height: 200)
        .background {
            Color.darkBlue
        }
    }
}
