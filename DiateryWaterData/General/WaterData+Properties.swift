//
//  WaterData+Properties.swift
//
//
//  Created by Roland Kajatin on 11/06/2023.
//

import HealthKit
import Foundation

extension WaterData {
    var todaysRecords: [HKQuantitySample] {
        samples.filter {
            Calendar.autoupdatingCurrent.isDateInToday($0.endDate)
        }
    }
    
    var yesterdaysRecords: [HKQuantitySample] {
        samples.filter {
            Calendar.autoupdatingCurrent.isDateInYesterday($0.endDate)
        }
    }
    
    public var averageThisWeek: Double {
        let sum = samples.filter {
            Calendar.autoupdatingCurrent.isDate($0.endDate, equalTo: Date.now, toGranularity: .weekOfYear)
        }.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum / 7
    }
    
    public var averageLastWeek: Double {
        let sum = samples.filter {
            Calendar.autoupdatingCurrent.isDate($0.endDate, equalTo: Date(timeIntervalSinceNow: -(7 * 24 * 60 * 60)), toGranularity: .weekOfYear)
        }.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum / 7
    }
    
    public var remainder: Double {
        return target - progress
    }
    
    public var progress: Double {
        let sum = todaysRecords.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum
    }
    
    public var progressNormalized: Double {
        return progress / target
    }
    
    public var progressYesterday: Double {
        let sum = yesterdaysRecords.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum
    }
    
    public var mostRecentRecord: HKQuantitySample {
        if samples.isEmpty {
            // Return a dummy old sample with 0 volume
            return HKQuantitySample(type: HKQuantityType(.dietaryWater), quantity: HKQuantity(unit: .literUnit(with: .milli), doubleValue: 0), start: Date(timeIntervalSince1970: 0), end: Date(timeIntervalSince1970: 0))
        }
        
        return samples.sorted(by: {
            $0.endDate.compare($1.endDate) == .orderedDescending
        })[0]
    }
    
    public var projected: Double {
        let midnight = Calendar(identifier: .gregorian).startOfDay(for: Date(timeIntervalSinceNow: 86400))
        let timeUntilMidnight = midnight.timeIntervalSinceNow
        // TODO: Calculate average intake for real
        let averageIntake: Double = 200
        return progress + (averageIntake * Double(timeUntilMidnight) / 3600)
    }
    
    public var showTimeToDrinkWarning: Bool {
        return mostRecentRecord.endDate < Date(timeIntervalSinceNow: -notificationInterval)
    }
    
    public var showOffTrackWarning: Bool {
        return projected < target
    }
    
    public func normalizedProgress(for date: Date) -> CGFloat {
        let sum = samples.filter {
            Calendar.autoupdatingCurrent.isDate($0.endDate, equalTo: date, toGranularity: .day)
        }.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum / target
    }
}
