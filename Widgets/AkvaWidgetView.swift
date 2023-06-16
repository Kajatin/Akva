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
            AquaAccessoryRectangular(target: entry.data?.target ?? 0, progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0)
        case .accessoryCircular:
            AquaAccessoryCircular(progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0)
        default:
            AquaDefault(target: entry.data?.target ?? 0, progress: entry.data?.progress ?? 0, progressNormalized: entry.data?.progressNormalized ?? 0)
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
    
    var body: some View {
        CircularProgressBar(radius: 130, target: 3000, progress: 1850, progressNormalized: 0.7)
            .padding(.all, 5)
    }
}

#Preview {
    AkvaWidgetView(entry: .empty)
        .previewContext(WidgetPreviewContext(family: .accessoryCircular))
}
