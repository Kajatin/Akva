//
//  Details.swift
//  Akva Watch App
//
//  Created by Roland Kajatin on 15/06/2023.
//

import Charts
import SwiftUI
import SwiftData
import DiateryWaterData

struct Details: View {
    var data: WaterData
    var color = Color("AccentColorOther")

    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(alignment:. firstTextBaseline) {
                    Text("Projected")
                    Text("\(Int(data.projected).formatted())")
                        .bold()
                    Text("mL")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Divider()
                    .padding(.vertical)
                ConsumptionGroup(value1: data.averageLastWeek, legend1: "Last week", value2: data.averageThisWeek, legend2: "This week", color: color)
                Divider()
                    .padding(.vertical)
                ConsumptionGroup(value1: data.progressYesterday, legend1: "Yesterday", value2: data.progress, legend2: "Today", color: color)
            }
            .safeAreaPadding(.horizontal)
            .tint(color)
            .containerBackground(color.gradient, for: .tabView)
            .navigationTitle("Trends")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ConsumptionGroup: View {
    var value1: Double
    var legend1: String
    var value2: Double
    var legend2: String
    var color: Color

    var body: some View {
        VStack(alignment: .leading) {
            ConsumptionBar(consumption: value1, ratio: max(0.01, min(CGFloat(value1 / value2), 1.0)), fill: Color.secondary, legend: legend1)
            ConsumptionBar(consumption: value2, ratio: max(0.01, min(CGFloat(value2 / value1), 1.0)), fill: color, legend: legend2)
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
                    .bold()
                Text("mL")
                    .foregroundColor(.secondary)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(fill)
                        .frame(width: geometry.size.width * max(ratio, 0.03), height: 25)
                    if ratio > 0.53 {
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
        Details(data: model)
    }
}
