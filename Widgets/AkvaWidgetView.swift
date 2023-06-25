//
//  AkvaWidgetView.swift
//  AkvaWidgetExtension
//
//  Created by Roland Kajatin on 16/06/2023.
//

import SwiftUI
import WidgetKit

struct AkvaWidgetView : View {
    var entry: AkvaSnapshotTimelineProvider.Entry

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryRectangular:
            AkvaAccessoryRectangular(progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0, lastIntakeTime: entry.data?.mostRecentRecord.endDate ?? .now)
        case .accessoryCircular:
            AkvaAccessoryCircular(progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0)
        case .accessoryInline:
            AkvaAccessoryInline(target: entry.data?.target ?? 0, progress: entry.data?.progress ?? 0)
        case .accessoryCorner:
            AkvaAccessoryCorner(target: entry.data?.target ?? 0, progress: entry.data?.progress ?? 0)
        default:
            AkvaDefault(target: entry.data?.target ?? 0, progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0)
        }
    }
}

struct AkvaAccessoryRectangular: View {
    var progress: Double
    var progressNormalized: Double
    var lastIntakeTime: Date

    var body: some View {
        HStack(spacing: 10) {
            Gauge(value: progressNormalized) {
                Text("\((progressNormalized * 100).formatted())%")
            }
                .gaugeStyle(.accessoryCircularCapacity)
                .widgetAccentable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text("Akva")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .widgetAccentable()
                Text("\(progress.formatted()) mL")
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("\(lastIntakeTime.formatted(date: .omitted, time: .shortened))")
                }
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .containerBackground(.blue.gradient, for: .widget)
    }
}

struct AkvaAccessoryCircular: View {
    var progress: Double
    var progressNormalized: Double
    
    var body: some View {
        Gauge(value: progressNormalized) {
            Text("\((progressNormalized * 100).formatted())%")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(.blue)
        .widgetAccentable()
        .containerBackground(.black, for: .widget)
    }
}

struct AkvaAccessoryInline: View {
    var target: Double
    var progress: Double
    
    var body: some View {
        ViewThatFits{
            HStack {
                Image(systemName: "drop.fill")
                Text("\(progress.formatted())/\(target.formatted()) mL")
            }
            HStack {
                Image(systemName: "drop.fill")
                Text("\(progress.formatted()) mL")
            }
            HStack {
                Image(systemName: "drop.fill")
                Text("\((100 * progress / target).rounded(.towardZero).formatted())%")
            }
        }
        .containerBackground(.black, for: .widget)
    }
}

struct AkvaAccessoryCorner: View {
    var target: Double
    var progress: Double
    
    var body: some View {
        Text("\((100 * progress / max(target, 0.00001)).rounded(.towardZero).formatted())%")
            .widgetCurvesContent()
            .widgetLabel {
                ProgressView(value: progress, total: target)
            }
            .tint(.blue)
            .widgetAccentable()
            .containerBackground(.blue.gradient, for: .widget)
    }
}

struct AkvaDefault: View {
    var target: Double
    var progress: Double
    var progressNormalized: Double
    
    var body: some View {
        CircularProgressBar(radius: 130, target: target, progress: progress, progressNormalized: progressNormalized)
            .padding(.all, 5)
            .containerBackground(.background, for: .widget)
    }
}

#Preview(as: .accessoryCircular) {
    AkvaWidget()
} timeline: {
    AkvaWidgetEntry(date: .now)
}
