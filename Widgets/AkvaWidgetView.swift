//
//  AkvaWidgetView.swift
//  AkvaWidgetExtension
//
//  Created by Roland Kajatin on 16/06/2023.
//

import SwiftUI
import SwiftData
import WidgetKit
import DiateryWaterData

struct AkvaWidgetView : View {
    var entry: AkvaSnapshotTimelineProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryRectangular:
            AquaAccessoryRectangular(target: entry.data?.target ?? 0, progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0)
        case .accessoryCircular:
            AquaAccessoryCircular(progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0)
        default:
            AquaDefault(target: entry.data?.target ?? 0, progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0, lastDate: entry.data?.lastUpdated ?? .now, timeToDrink: NotificationManager.shared.timeToDrink)
        }
    }
}

struct AquaAccessoryRectangular: View {
    var target: Double
    var progress: Double
    var progressNormalized: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(target.formatted()) mL")
            Text("\(progress.formatted()) mL")
                .font(.system(size: 18))
                .fontWeight(.bold)
            Gauge(value: progressNormalized) {
                Image(systemName: "drop.fill")
            }
            .gaugeStyle(.accessoryLinear)
        }
        .privacySensitive()
    }
}

struct AquaAccessoryCircular: View {
    var progress: Double
    var progressNormalized: Double
    
    var body: some View {
        ZStack {
            Gauge(value: progressNormalized) {
                Image(systemName: "drop.fill")
            }
            .gaugeStyle(.accessoryCircular)
            
            Text("\(progress.formatted())")
        }
        .privacySensitive()
    }
}

struct AquaDefault: View {
    var target: Double
    var progress: Double
    var progressNormalized: Double
    var lastDate: Date
    var timeToDrink: Bool
    
    let gradient = Gradient(colors: [.accentColor.opacity(0.6), .accentColor])
    
    var body: some View {
        ZStack {
            Color(.gray)
                .opacity(0.1)
            VStack(alignment: .leading) {
                HStack {
                    if timeToDrink {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                    Spacer()
                    Label("\(lastDate.formatted(date: .omitted, time: .shortened))", systemImage: "clock.arrow.circlepath")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                HStack(alignment: .firstTextBaseline,spacing: 4) {
                    Text("\(max(target-progress, 0).formatted())")
                        .font(.system(size: 16))
                        .privacySensitive()
                    Text("mL")
                        .font(.system(size: 12))
                }
                .foregroundColor(.secondary)
                
                HStack(alignment: .firstTextBaseline,spacing: 4) {
                    Text("\(progress.formatted())")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 24))
                        .bold()
                        .privacySensitive()
                    Text("mL")
                        .foregroundColor(.secondary)
                        .font(.system(size: 20))
                }
                
                Gauge(value: progressNormalized) {
                    //                Image(systemName: "drop.fill")
                }
                .gaugeStyle(.linearCapacity)
                //                .tint(gradient)
                .privacySensitive()
                .padding(.bottom, 4)
            }
            .padding()
        }
    }
}
