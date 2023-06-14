//
//  NotificationManager.swift
//
//  Created by Roland Kajatin on 10/06/2023.
//

import OSLog
import SwiftData
import Foundation
import UserNotifications

private let logger = Logger(subsystem: "DiateryWaterData", category: "Notification")

@Observable
public class NotificationManager {
    public static let shared = NotificationManager()
    
    public var badge: Int = 0
    public var timeToDrink: Bool = false
    internal let notificationCenter: UNUserNotificationCenter
    private var delegate: NotificationManagerDelegate? = nil

    private init() {
        notificationCenter = UNUserNotificationCenter.current()
        delegate = NotificationManagerDelegate() { content in
            DispatchQueue.main.async {
                self.timeToDrink = true
                self.badge = content.badge?.intValue ?? 0
                logger.info("\(self.timeToDrink)")
            }
        }
        notificationCenter.delegate = delegate
    }

    public func isNotificationsAuthorized() async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus == .authorized
    }

    public func requestAuthorization() async throws -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        return try await UNUserNotificationCenter.current().requestAuthorization(options: options)
    }
}

public extension NotificationManager {
    static let notificationTimeToDrinkIdentifier = "time-to-drink"
}
