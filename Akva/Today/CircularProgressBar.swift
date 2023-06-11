//
//  CircularProgressBar.swift
//  Aqua
//
//  Created by Roland Kajatin on 01/10/2022.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct CircularProgressBar: View {
    var radius: CGFloat
    var widget = false
    
    @Query private var waterData: [WaterData]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if let data = waterData.first {
            ZStack {
                Circle()
                    .stroke(Color.secondary, lineWidth: 25)
                    .frame(width: radius * 2)
                    .opacity(colorScheme == .light ? 0.2 : 0.25)
                
                Circle()
                    .trim(from: 0, to: CGFloat(data.progressNormalized == 0 ? 0.01 : data.progressNormalized))
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .frame(width: radius * 2)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.75), value: data.progressNormalized)
                
                if widget {
                    Text("\(Int(data.progress))")
                        .foregroundColor(Color.accentColor)
                        .font(.title)
                        .bold()
                } else {
                    VStack(alignment: .center, spacing: 10) {
                        Text("\(Int(data.progress))")
                            .foregroundColor(Color.accentColor)
                            .font(.system(size: 42, weight: .semibold, design: .rounded))
                            .bold()
                        Text("\(Int(data.target))")
                            .foregroundColor(Color.secondary)
                            .font(.system(size: 22, weight: .regular, design: .rounded))
                            .bold()
                    }
                }
            }
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}

#Preview {
    CircularProgressBar(radius: 125)
        .waterDataContainer(inMemory: true)
}
