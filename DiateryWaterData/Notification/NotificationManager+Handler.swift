//
//  NotificationManager+Handler.swift
//
//
//  Created by Roland Kajatin on 10/06/2023.
//

import OSLog
import Foundation
import UserNotifications

private let logger = Logger(subsystem: "DiateryWaterData", category: "Notification")

extension NotificationManager {
    internal func scheduleTimeToDrinkNotification(timeInterval: TimeInterval, dateWhenShows: Date?, onError: @escaping (Error?) -> Void) {
        if (!notificationEnabled) {
            logger.warning("Tried to schedule notification but they are disabled")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Time to drink"
        //        content.subtitle = "Subtitle"
        if let date = dateWhenShows {
            content.body = "You last drank \(Date.now.relativeDateString(to: date))"
        } else {
            content.body = "Remember to stay hydrated"
        }
        if (soundEnabled) {
            content.sound = UNNotificationSound.default
        }
        content.badge = 1

        // Fire in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        // Create the request
        let request = UNNotificationRequest(identifier: NotificationManager.notificationTimeToDrinkIdentifier, content: content, trigger: trigger)

        // Schedule the request with the system
        notificationCenter.add(request, withCompletionHandler: onError)

        logger.info("Scheduled notification for \(timeInterval) seconds from now")
    }

    internal func cancelPreviousNotifications() {
        badge = 0
        timeToDrink = false
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [NotificationManager.notificationTimeToDrinkIdentifier])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [NotificationManager.notificationTimeToDrinkIdentifier])
    }
}
