//
//  StatsView.swift
//  Aqua
//
//  Created by Roland Kajatin on 28/09/2022.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct StatsView: View {
    var data: WaterData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Highlights")
                .font(.title2)
                .bold()
            VStack(spacing: 15) {
                if (data.progress != 0 || data.progressYesterday != 0) {
                    StatsViewDaily(progress: data.progress, progressYesterday: data.progressYesterday)
                }
                if (data.averageThisWeek != 0 || data.averageLastWeek != 0) {
                    StatsViewWeekly(averageThisWeek: data.averageThisWeek, averageLastWeek: data.averageLastWeek)
                }
            }
        }
    }
}

struct StatsViewDaily: View {
    var progress: Double
    var progressYesterday: Double
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                let comparisonText = { () -> String in
                    if (progress > progressYesterday) {
                        return "more water than"
                    } else if (progress == progressYesterday) {
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
                    ConsumptionBar(consumption: progress, ratio: min(CGFloat(progress / progressYesterday), 1.0), fill: Color.accentColor, legend: "Today")
                    ConsumptionBar(consumption: progressYesterday, ratio: min(CGFloat(progressYesterday / progress), 1.0), fill: Color.secondary, legend: "Yesterday")
                }
            }
        }
    }
}

struct StatsViewWeekly: View {
    var averageThisWeek: Double
    var averageLastWeek: Double
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                let comparisonText = { () -> String in
                    if (averageThisWeek > averageLastWeek) {
                        return "higher than"
                    } else if (averageThisWeek == averageLastWeek) {
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
                    ConsumptionBar(consumption: averageThisWeek, ratio: min(CGFloat(averageThisWeek / averageLastWeek), 1.0), fill: Color.accentColor, legend: "This week")
                    ConsumptionBar(consumption: averageLastWeek, ratio: min(CGFloat(averageLastWeek / averageThisWeek), 1.0), fill: Color.secondary, legend: "Last week")
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

#Preview {
    ModelPreview { model in
        StatsView(data: model)
    }
}
