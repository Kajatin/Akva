//
//  NotificationManagerDelegate.swift
//
//
//  Created by Roland Kajatin on 13/06/2023.
//

import Foundation
import UserNotifications

class NotificationManagerDelegate: NSObject, UNUserNotificationCenterDelegate {
    private let onNotification: () -> Void
    
    init(onTimeToDrink: @escaping () -> Void) {
        onNotification = onTimeToDrink
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if (notification.request.identifier == NotificationManagerNew.notificationTimeToDrinkIdentifier) {
            onNotification()
        }
        
        completionHandler(.sound)
    }
}
