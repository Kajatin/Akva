//
//  WaterData+Actions.swift
//
//  Created by Roland Kajatin on 11/06/2023.
//

import OSLog
import HealthKit
import WidgetKit
import Foundation

private let logger = Logger(subsystem: "DiateryWaterData", category: "General")

extension WaterData {
    public func addConsumption(quantity: Double, date: Date) {
        let sample = HealthStoreManager.shared.createWaterSample(quantity: quantity, date: date)
        HealthStoreManager.shared.writeWaterSample(sample) { success, error in
            if (success) {
                logger.info("Successfully added new water sample to Apple Health")
                self.lastUpdated = .now
                self.samples.append(sample)
                
                WidgetCenter.shared.reloadAllTimelines()
                
                // Cancel pending time-to-drink notifications
                NotificationManager.shared.cancelPreviousNotifications()
                
                if (self.progress >= self.target) {
                    return
                }
                
                // Schedule notification for later
                let midnight = Calendar(identifier: .gregorian).startOfDay(for: Date(timeIntervalSinceNow: 86400))
                let timeUntilMidnight = midnight.timeIntervalSinceNow
                let averageIntake: Double = 200
                let timeInterval = (averageIntake * Double(timeUntilMidnight)) / Double(self.remainder)
                let fireIn: Double = min(timeInterval, self.notificationInterval)
                let dateWhenNotificationShows = Date(timeInterval: fireIn, since: date)
                NotificationManager.shared.scheduleTimeToDrinkNotification(timeInterval: fireIn, dateWhenShows: dateWhenNotificationShows) { error in
                    if error != nil {
                        self.error = error
                        logger.error("Error while scheduling new notification: \(String(describing: error))")
                    }
                }
            } else {
                self.error = error
                logger.error("Failed to add water sample to Apple Health: \(String(describing: error))")
            }
        }
    }
}
