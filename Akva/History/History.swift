//
//  History.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct History: View {
    @Environment(\.calendar) var calendar
    @Environment(\.colorScheme) var colorScheme
    // TODO: handle loading properly here
    @State private var isLoading = false
    
    @Query private var waterData: [WaterData]
    
    private var year: DateInterval {
        calendar.dateInterval(of: .year, for: Date())!
    }
    
    var body: some View {
        Group {
            if isLoading {
                VStack {
                    ProgressView() // Or your custom skeleton view
                }
            } else {
                if let data = waterData.first {
                    CalendarProgressView(interval: year) { date in
                        let normProgress = data.normalizedProgress(for: date)
                        let opacity = date > Date() ? 0.65 : 1
                        let dateNumberColor = Calendar.autoupdatingCurrent.isDateInToday(date) && normProgress < 1 ? Color.accentColor : .primary
                        ZStack {
                            if normProgress >= 1 {
                                Circle()
                                    .foregroundColor(.accentColor)
                            } else {
                                Circle()
                                    .stroke(Color.secondary, lineWidth: 6)
                                    .opacity(colorScheme == .light ? 0.2 : 0.25)
                                
                                Circle()
                                    .trim(from: 0, to: data.normalizedProgress(for: date))
                                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                            }
                            Text(String(self.calendar.component(.day, from: date)))
                                .foregroundColor(dateNumberColor)
                                .bold()
                        }
                        .padding(6)
                        .opacity(opacity)
                    }
                    .padding(.horizontal)
                } else {
                    ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
                }
            }
        }.onAppear {
            
        }
    }
}

fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let week: Date
    let content: (Date) -> DateView
    
    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }
    
    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
        else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}

struct DayLetter: Identifiable {
    let id: UUID
    let name: String
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let month: Date
    let showHeader: Bool
    let content: (Date) -> DateView
    let dayLetters: [DayLetter] = [
        DayLetter(id: .init(), name: "M"),
        DayLetter(id: .init(), name: "T"),
        DayLetter(id: .init(), name: "W"),
        DayLetter(id: .init(), name: "T"),
        DayLetter(id: .init(), name: "F"),
        DayLetter(id: .init(), name: "S"),
        DayLetter(id: .init(), name: "S"),
    ]
    
    init(
        month: Date,
        showHeader: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
        self.showHeader = showHeader
    }
    
    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
    
    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        return Text(formatter.string(from: month))
            .font(.headline)
            .padding(.bottom, 2)
            .padding(.top, 14)
            .opacity(0.7)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if showHeader {
                header
            }
            
            HStack(alignment: .center, spacing: 8) {
                ForEach(dayLetters, id: \.id) { letter in
                    Spacer()
                    Text(letter.name)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}

struct CalendarProgressView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let interval: DateInterval
    let content: (Date) -> DateView
    
    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(months, id: \.self) { month in
                    MonthView(month: month, content: self.content)
                }
            }
        }
    }
}

#Preview {
    History()
        .waterDataContainer(inMemory: true)
}
