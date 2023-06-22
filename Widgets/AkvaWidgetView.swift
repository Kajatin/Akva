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
            AkvaAccessoryRectangular(target: entry.data?.target ?? 0, progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0)
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
        .containerBackground(Color.accentColor, for: .widget)
    }
}

struct AkvaAccessoryCircular: View {
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
        .containerBackground(Color.accentColor, for: .widget)
    }
}

struct AkvaAccessoryInline: View {
    var target: Double
    var progress: Double
    
    var body: some View {
        ViewThatFits{
            Text("\(progress.formatted())/\(target.formatted()) mL consumed")
            Text("\(progress.formatted()) mL consumed")
            Text("\((100 * progress / target).rounded(.towardZero).formatted())% consumed")
            Text("\(progress.formatted()) mL")
            Text("\((100 * progress / target).rounded(.towardZero).formatted())%")
        }
        .containerBackground(Color.accentColor, for: .widget)
    }
}

struct AkvaAccessoryCorner: View {
    var target: Double
    var progress: Double
    
    var body: some View {
        Text("\((100 * progress / target).rounded(.towardZero).formatted())%")
            .font(.title)
            .widgetLabel {
                ProgressView(value: progress, total: target)
//                    .tint(entry.color)
                    .tint(.blue)
                    .widgetAccentable()
            }
            .containerBackground(Color.accentColor, for: .widget)
    }
}

struct AkvaDefault: View {
    var target: Double
    var progress: Double
    var progressNormalized: Double
    
    var body: some View {
        CircularProgressBar(radius: 130, target: 3000, progress: 1850, progressNormalized: 0.7)
            .padding(.all, 5)
            .containerBackground(.background, for: .widget)
    }
}

#Preview(as: .accessoryCircular) {
    AkvaWidget()
} timeline: {
    AkvaWidgetEntry(date: .now)
}
