//
//  AquaWidget.swift
//  AquaWidget
//
//  Created by Roland Kajatin on 04/10/2022.
//

import SwiftUI
import SwiftData
import WidgetKit
import DiateryWaterData

struct AkvaWidget: Widget {
    private let kind = "Akva Widget"
    
    var families: [WidgetFamily] {
        #if os(iOS)
        return [.accessoryCircular, .accessoryRectangular, .systemSmall]
        #elseif os(watchOS)
        return [.accessoryCircular, .accessoryRectangular, .accessoryInline, .accessoryCorner]
        #endif
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: AkvaSnapshotTimelineProvider()
        ) { entry in
            AkvaWidgetView(entry: entry)
        }
        .configurationDisplayName("Akva")
        .description("Keep track of your water intake.")
        .supportedFamilies(families)
    }
}

#Preview(as: .accessoryCircular) {
    AkvaWidget()
} timeline: {
    AkvaWidgetEntry(date: .now)
}
