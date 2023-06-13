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

public class NotificationManager {
    public static let shared = NotificationManager()
    
    public var badge: Int = 3
    public var timeToDrink: Bool = false
    internal let notificationCenter: UNUserNotificationCenter
    lazy private var delegate: NotificationManagerDelegate = {
        return NotificationManagerDelegate() { [weak self] in
            DispatchQueue.main.async {
                self?.timeToDrink = true
                
                let modelContext = ModelContext(WaterData.container)
                guard let waterData = try! modelContext.fetch(FetchDescriptor<WaterData>()).first else {
                    logger.warning("No ModelContext for WaterData")
                    return
                }
                
                waterData.timeToDrink = true
                logger.info("\(waterData.timeToDrink)")
            }
        }
    }()

    private init() {
        notificationCenter = UNUserNotificationCenter.current()
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
