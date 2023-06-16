//
//  Date+Format.swift
//
//
//  Created by Roland Kajatin on 15/06/2023.
//

import Foundation

public extension Date {
    func relativeDayString() -> String {
        if (Calendar.autoupdatingCurrent.isDateInToday(self)) {
            return "Today"
        } else if (Calendar.autoupdatingCurrent.isDateInYesterday(self)) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(for: self)!
        }
    }
    
    func relativeDateString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date.now)
    }
    
    func relativeDateString(to: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: to)
    }
}
