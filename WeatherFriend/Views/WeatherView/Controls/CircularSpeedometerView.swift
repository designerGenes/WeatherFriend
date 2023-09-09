//
//  CircularSpeedometerView.swift
//  WeatherFriend
//
//  Created by Jaden Nation on 9/7/23.
//

import SwiftUI

struct CircularSpeedometerView: View {
    enum UnitType {
        case celsius
        case fahrenheit
        case percent
        case plain
        case milesPerHour
        case kilometersPerHour
    }
    
    var title: String
    var value: Double = 0
    var maxValue: Double = 100
    var threshold: Double = 0
    var unit: UnitType = .plain
    var color: Color
    @State private var showTitle: Bool = false
    var maxValueColor: Color?
    
    var shouldUseMaxValueColor: Bool {
        switch unit {
        case .percent:
            return (value / maxValue) * 100 > threshold
        default:
            return value > threshold
        }
    }
    
    var currentFillColor: Color {
        return threshold > 0 && shouldUseMaxValueColor ? (maxValueColor ?? color) : color
    }
    
    var formattedValue: String {
        switch unit {
        case .celsius:
            return "\(Int(value))° C"
        case .fahrenheit:
            return "\(Int(value))° F"
        case .percent:
            return "\((value * 100).rounded())%"
        case .plain:
            return "\(Int(value))"
        case .milesPerHour:
            return "\(Int(value)) mph"
        case .kilometersPerHour:
            return "\(Int(value)) kph"
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.lightGray.opacity(1))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(value / maxValue, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(currentFillColor)
                    .rotationEffect(Angle(degrees: 90))
                
                
            }
            .frame(width: 30, height: 30)
            
            Text(showTitle ? title : formattedValue)
                .multilineTextAlignment(.center)
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

struct CircularSpeedometerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CircularSpeedometerView(title: "Temp", value: 100, maxValue: 130, threshold: 100, unit: .fahrenheit, color: .blue, maxValueColor: .red)
        }
    }
}
