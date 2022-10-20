//
//  NotificationManager.swift
//  Aqua
//
//  Created by Roland Kajatin on 02/10/2022.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    private let notificationCenter: UNUserNotificationCenter
    private let identifierTimeToDrink: String
    private let onNotification: () -> Void
    
//    let midnight = Calendar(identifier: .gregorian).startOfDay(for: Date(timeIntervalSinceNow: 86400))
    
    init(onTimeToDrink: @escaping () -> Void) {
        notificationCenter = UNUserNotificationCenter.current()
        identifierTimeToDrink = "time-to-drink"
        onNotification = onTimeToDrink
        
        super.init()
        
        notificationCenter.delegate = self
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: completion)
    }
    
    func isAuthorization(completion: @escaping (UNNotificationSettings) -> Void) -> Void {
        notificationCenter.getNotificationSettings(completionHandler: completion)
    }
    
    func scheduleTimeToDrinkNotification(timeInterval: TimeInterval, dateWhenShows: Date?, onError: @escaping (Error?) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "Take a Sip"
//        content.subtitle = "Subtitle"
        if let date = dateWhenShows {
            content.body = "You last drank \(Date.now.relativeDateString(to: date))"
        } else {
            content.body = "Remember to stay hydrated"
        }
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        // Fire in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: identifierTimeToDrink, content: content, trigger: trigger)
        
        // Schedule the request with the system
        notificationCenter.add(request, withCompletionHandler: onError)
    }
    
    func cancelPreviousNotifications() {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifierTimeToDrink])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifierTimeToDrink])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if (notification.request.identifier == "time-to-drink") {
            onNotification()
            print("Time to drink notification handler")
        }
        
        completionHandler(.sound)
    }
    
}
