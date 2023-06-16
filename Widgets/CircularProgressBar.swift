//
//  CircularProgressBar.swift
//  AkvaWidgetExtension
//
//  Created by Roland Kajatin on 17/06/2023.
//

import SwiftUI

struct CircularProgressBar: View {
    var radius: CGFloat
    var target: Double
    var progress: Double
    var progressNormalized: Double
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary, lineWidth: 12)
                .frame(width: radius * 2)
                .opacity(colorScheme == .light ? 0.2 : 0.25)
            
            Circle()
                .trim(from: 0, to: CGFloat(progressNormalized == 0 ? 0.01 : progressNormalized))
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .frame(width: radius * 2)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.75), value: progressNormalized)
            
            VStack(alignment: .center, spacing: 4) {
                Text("\(Int(progress))")
                    .foregroundColor(Color.accentColor)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                Text("\(Int(target))")
                    .foregroundColor(Color.secondary)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
            }
        }
    }
}

#Preview {
    CircularProgressBar(radius: 125, target: 3250, progress: 1750, progressNormalized: 0.3)
}
