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
    @Query private var waterData: [WaterData]
    
    var body: some View {
        if let data = waterData.first {
            VStack(alignment: .leading) {
                Text("Highlights")
                    .font(.title2)
                    .bold()
                VStack(spacing: 15) {
                    if (data.progress != 0 || data.progressYesterday != 0) {
                        StatsViewDaily()
                    }
                    if (data.averageThisWeek != 0 || data.averageLastWeek != 0) {
                        StatsViewWeekly()
                    }
                }
            }
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}

struct StatsViewDaily: View {
    @Query private var waterData: [WaterData]
    
    var body: some View {
        if let data = waterData.first {
            GroupBox {
                VStack(alignment: .leading) {
                    let comparisonText = { () -> String in
                        if (data.progress > data.progressYesterday) {
                            return "more water than"
                        } else if (data.progress == data.progressYesterday) {
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
                        ConsumptionBar(consumption: data.progress, ratio: min(CGFloat(data.progress / data.progressYesterday), 1.0), fill: Color.accentColor, legend: "Today")
                        ConsumptionBar(consumption: data.progressYesterday, ratio: min(CGFloat(data.progressYesterday / data.progress), 1.0), fill: Color.secondary, legend: "Yesterday")
                    }
                }
            }
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}

struct StatsViewWeekly: View {
    @Query private var waterData: [WaterData]
    
    var body: some View {
        if let data = waterData.first {
            GroupBox {
                VStack(alignment: .leading) {
                    let comparisonText = { () -> String in
                        if (data.averageThisWeek > data.averageLastWeek) {
                            return "higher than"
                        } else if (data.averageThisWeek == data.averageLastWeek) {
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
                        ConsumptionBar(consumption: data.averageThisWeek, ratio: min(CGFloat(data.averageThisWeek / data.averageLastWeek), 1.0), fill: Color.accentColor, legend: "This week")
                        ConsumptionBar(consumption: data.averageLastWeek, ratio: min(CGFloat(data.averageLastWeek / data.averageThisWeek), 1.0), fill: Color.secondary, legend: "Last week")
                    }
                }
            }
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
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
    StatsView()
        .waterDataContainer(inMemory: true)
}
