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
    @Bindable var waterData: WaterData
    var color = Color.green
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(alignment:. firstTextBaseline) {
                    Text("Projected")
                    Text("\(Int(waterData.projected).formatted())")
                        .bold()
                    Text("mL")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Divider()
                    .padding(.vertical)
                ConsumptionGroup(value1: waterData.averageLastWeek, legend1: "Last week", value2: waterData.averageThisWeek, legend2: "This week", color: color)
                Divider()
                    .padding(.vertical)
                ConsumptionGroup(value1: waterData.progressYesterday, legend1: "Yesterday", value2: waterData.progress, legend2: "Today", color: color)
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
            ConsumptionBar(consumption: value1, ratio: min(CGFloat(value1 / value2), 1.0), fill: Color.secondary, legend: legend1)
            ConsumptionBar(consumption: value2, ratio: min(CGFloat(value2 / value1), 1.0), fill: color, legend: legend2)
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
//                    .font(.title2)
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

struct DetailsO: View {
    @Bindable var waterData: WaterData
    var color = Color.green
    
    struct chartItem: Identifiable {
        public var id: Date { date }
        public let date: Date
        public let consumption: Float
    }
    
    func createDailyRecordsChartData(_ records: Dictionary<Date, Double>) -> [chartItem] {
        records.map { record in
            return chartItem(date: record.key, consumption: Float(record.value))
        }
    }
    
    var body: some View {
        Chart(createDailyRecordsChartData(waterData.dailyRecords)) { data in
            RuleMark(y: .value("Target", waterData.target)).foregroundStyle(.white)
            BarMark(
                x: .value("Date", data.date),
                y: .value("Consumption", data.consumption),
                width: .fixed(10)
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("ReachedTarget", Double(data.consumption) >= waterData.target ? "fulfilled" : "failed"))
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel(format: Date.FormatStyle().weekday(), centered: true)
                    .offset(y:2)
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(.gray)

                if value.index < (value.count - 1) {
                    AxisValueLabel(format: IntegerFormatStyle<Int>())
                        .offset(x:5)
                }
            }
        }
        .chartForegroundStyleScale(["failed": .gray, "fulfilled": color])
        .chartLegend(.hidden)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 60 * 60 * 24 * 7)
//        .chartScrollPosition(x: $scrollPosition)
        .chartScrollTargetBehavior(
            .valueAligned(
                matching: DateComponents(day: 1),
                majorAlignment: .matching(DateComponents(weekday: 1))
            )
        )
        .padding([.leading, .trailing])
        .tint(color)
        .containerBackground(color.gradient, for: .tabView)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                } label: {
                    Label("Chart", systemImage: "chart.bar.fill")
                }
            }
        }
    }
}

//#Preview {
//    Details()
//}
