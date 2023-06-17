//
//  NotificationManagerDelegate.swift
//
//
//  Created by Roland Kajatin on 13/06/2023.
//

import Foundation
import UserNotifications

class NotificationManagerDelegate: NSObject, UNUserNotificationCenterDelegate {
    private let onNotification: (UNNotificationContent) -> Void
    
    init(onTimeToDrink: @escaping (UNNotificationContent) -> Void) {
        onNotification = onTimeToDrink
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if (notification.request.identifier == NotificationManager.notificationTimeToDrinkIdentifier) {
            onNotification(notification.request.content)
        }
        
        var options: UNNotificationPresentationOptions = .badge
        if (NotificationManager.shared.soundEnabled) {
            options = .sound
        }
        completionHandler(options)
    }
}
