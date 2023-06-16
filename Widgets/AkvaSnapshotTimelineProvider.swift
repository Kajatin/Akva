//
//  AkvaSnapshotTimelineProvider.swift
//  AkvaWidgetExtension
//
//  Created by Roland Kajatin on 16/06/2023.
//

import OSLog
import SwiftData
import WidgetKit
import DiateryWaterData

private let logger = Logger(subsystem: "Widgets", category: "AkvaSnapshotTimelineProvider")

struct AkvaWidgetEntry: TimelineEntry {
    var data: WaterData?
    let date: Date
    
    static var empty: Self {
        Self(date: .now)
    }
}

struct AkvaSnapshotTimelineProvider: TimelineProvider {
    let modelContext = ModelContext(WaterData.container)

    func waterData() -> [WaterData] {
        return try! modelContext.fetch(FetchDescriptor<WaterData>())
    }
    
    func placeholder(in context: Context) -> AkvaWidgetEntry {
        AkvaWidgetEntry.empty
    }

    func getSnapshot(in context: Context, completion: @escaping (AkvaWidgetEntry) -> Void) {
        guard let data = waterData().first else {
            completion(.empty)
            return
        }
        completion(AkvaWidgetEntry(data: data, date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AkvaWidgetEntry>) -> ()) {
        var entries: [AkvaWidgetEntry] = []

        // Generate a timeline consisting of a single entry
        let currentDate: Date = .now
        if let data = waterData().first {
            let entry = AkvaWidgetEntry(data: data, date: currentDate)
            entries.append(entry)
        } else {
            entries.append(.empty)
        }

        let updateAfter = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(updateAfter))
        completion(timeline)
    }
}
