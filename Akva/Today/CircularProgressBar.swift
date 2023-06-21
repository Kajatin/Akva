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
    var target: Double
    var progress: Double
    var progressNormalized: Double

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary, lineWidth: 25)
                .frame(width: radius * 2)
                .opacity(colorScheme == .light ? 0.2 : 0.25)

            Circle()
                .trim(from: 0, to: CGFloat(progressNormalized == 0 ? 0.01 : progressNormalized))
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(width: radius * 2)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.75), value: progressNormalized)

           VStack(alignment: .center, spacing: 10) {
                Text("\(Int(progress))")
                    .foregroundColor(Color.accentColor)
                    .font(.system(size: 42, weight: .semibold, design: .rounded))
                    .bold()
                Text("\(Int(target))")
                    .foregroundColor(Color.secondary)
                    .font(.system(size: 22, weight: .regular, design: .rounded))
                    .bold()
            }
        }
    }
}

#Preview {
    ModelPreview { (model: WaterData) in
        CircularProgressBar(radius: 125, target: model.target, progress: model.progress, progressNormalized: model.progressNormalized)
    }
}

