//
//  AquaWidget.swift
//  AquaWidget
//
//  Created by Roland Kajatin on 04/10/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of a single entry
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate)
        entries.append(entry)

        let updateAfter = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(updateAfter))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    @AppStorage("waterProgress", store: UserDefaults(suiteName: "group.widget.com.gmail.roland.kajatin"))
    var progressShared: Double = 0
    @AppStorage("waterProgressNormalize", store: UserDefaults(suiteName: "group.widget.com.gmail.roland.kajatin"))
    var progressNormalizedShared: Double = 0
    @AppStorage("waterTarget", store: UserDefaults(suiteName: "group.widget.com.gmail.roland.kajatin"))
    var targetShared: Double = 0
    @AppStorage("waterTimeToDrink", store: UserDefaults(suiteName: "group.widget.com.gmail.roland.kajatin"))
    var timeToDrinkShared: Bool = false
    
    var lastDateShared = UserDefaults(suiteName: "group.widget.com.gmail.roland.kajatin")!.object(forKey: "waterLastDate") as? Date ?? Date()
    
    let date: Date
}

struct AquaWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryRectangular:
            AquaAccessoryRectangular(target: entry.targetShared, progress: entry.progressShared, progressNormalized: entry.progressNormalizedShared)
        case .accessoryCircular:
            AquaAccessoryCircular(progress: entry.progressShared, progressNormalized: entry.progressNormalizedShared)
        default:
            AquaDefault(target: entry.targetShared, progress: entry.progressShared, progressNormalized: entry.progressNormalizedShared, lastDate: entry.lastDateShared, timeToDrink: entry.timeToDrinkShared)
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

@main
struct AquaWidget: Widget {
    let kind: String = "AquaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AquaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Water Consumption")
        .description("Shows your water intake progression.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .systemSmall])
    }
}

struct AquaWidget_Previews: PreviewProvider {
    static var previews: some View {
        AquaWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
