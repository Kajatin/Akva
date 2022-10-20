//
//  CircularProgressBar.swift
//  Aqua
//
//  Created by Roland Kajatin on 01/10/2022.
//

import SwiftUI

struct CircularProgressBar: View {
    var radius: CGFloat
    var widget = false
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary, lineWidth: 25)
                .frame(width: radius * 2)
                .opacity(colorScheme == .light ? 0.2 : 0.25)
            
            Circle()
                .trim(from: 0, to: CGFloat(viewModel.progressNormalized == 0 ? 0.01 : viewModel.progressNormalized))
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(width: radius * 2)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.75), value: viewModel.progressNormalized)
            
            if widget {
                Text("\(Int(viewModel.progress))")
                    .foregroundColor(Color.accentColor)
                    .font(.title)
                    .bold()
            } else {
                VStack(alignment: .center, spacing: 10) {
                    Text("\(Int(viewModel.progress))")
                        .foregroundColor(Color.accentColor)
//                        .font(.largeTitle)
                        .font(.system(size: 42, weight: .semibold, design: .rounded))
                        .bold()
                    Text("\(Int(viewModel.target))")
                        .foregroundColor(Color.secondary)
                        .font(.system(size: 22, weight: .regular, design: .rounded))
                        .bold()
                }
            }
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        CircularProgressBar(radius: 125)
            .environmentObject(viewModel)
    }
}
