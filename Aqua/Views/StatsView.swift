//
//  StatsView.swift
//  Aqua
//
//  Created by Roland Kajatin on 28/09/2022.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Highlights")
                .font(.title2)
                .bold()
            VStack(spacing: 15) {
                StatsViewDaily()
                StatsViewWeekly()
            }
        }
    }
}

struct StatsViewDaily: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                let comparisonText = { () -> String in
                    if (viewModel.progress > viewModel.progressYesterday) {
                        return "more water than"
                    } else if (viewModel.progress == viewModel.progressYesterday) {
                        return "about the same amount of water as"
                    } else {
                        return "less water than"
                    }
                }
                
                Text("Today you're drinking \(comparisonText()) yesterday")
                    .font(.headline)
                    .bold()
                Divider()
                VStack(alignment: .leading) {
                    ConsumptionBar(consumption: viewModel.progress, ratio: min(CGFloat(viewModel.progress / viewModel.progressYesterday), 1.0), fill: Color.accentColor, legend: "Today")
                    ConsumptionBar(consumption: viewModel.progressYesterday, ratio: min(CGFloat(viewModel.progressYesterday / viewModel.progress), 1.0), fill: Color.secondary, legend: "Yesterday")
                }
            }
        }
    }
}

struct StatsViewWeekly: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                let comparisonText = { () -> String in
                    if (viewModel.averageThisWeek > viewModel.averageLastWeek) {
                        return "higher than"
                    } else if (viewModel.averageThisWeek == viewModel.averageLastWeek) {
                        return "about the same as"
                    } else {
                        return "lower than"
                    }
                }
                
                Text("This week your daily average water intake is \(comparisonText()) last week")
                    .font(.headline)
                    .bold()
                    .padding(.top, 1)
                Divider()
                VStack(alignment: .leading) {
                    ConsumptionBar(consumption: viewModel.averageThisWeek, ratio: min(CGFloat(viewModel.averageThisWeek / viewModel.averageLastWeek), 1.0), fill: Color.accentColor, legend: "This week")
                    ConsumptionBar(consumption: viewModel.averageLastWeek, ratio: min(CGFloat(viewModel.averageLastWeek / viewModel.averageThisWeek), 1.0), fill: Color.secondary, legend: "Last week")
                }
            }
        }
    }
}

struct ConsumptionBar: View {
    var consumption: Double
    var ratio: CGFloat
    var fill: Color
    var legend: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment:. firstTextBaseline) {
                Text("\(Int(consumption).formatted())")
                    .font(.title2)
                    .bold()
                Text("mL")
                    .foregroundColor(.secondary)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(fill)
                        .frame(width: geometry.size.width * max(ratio, 0.03), height: 25)
                    if ratio > 0.27 {
                        Text(legend)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    } else {
                        Text(legend)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.leading, 8)
                            .offset(x: geometry.size.width * max(ratio, 0.03))
                    }
                }
            }
            .frame(height: 25)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        StatsView().environmentObject(viewModel)
    }
}
