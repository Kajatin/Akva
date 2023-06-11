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
}
