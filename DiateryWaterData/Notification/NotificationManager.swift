//
//  NotificationManager.swift
//
//  Created by Roland Kajatin on 10/06/2023.
//

import Foundation
import UserNotifications

public class NotificationManagerNew {
    public static let shared = NotificationManagerNew()

    internal let notificationCenter: UNUserNotificationCenter

    private init() {
        notificationCenter = UNUserNotificationCenter.current()
    }
    
    public var badge: Int = 3

    public func isNotificationsAuthorized() async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus == .authorized
    }

    public func requestAuthorization() async throws -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        return try await UNUserNotificationCenter.current().requestAuthorization(options: options)
    }
}
