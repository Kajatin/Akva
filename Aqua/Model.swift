//
//  Model.swift
//  Aqua
//
//  Created by Roland Kajatin on 11/09/2022.
//

import SwiftUI
import Foundation
import HealthKit

struct Model: Codable {
    var target: Double = 3000
    var timeToDrink = false
    var timeToDrinkNotification = false
    var notificationInterval: Double = 3600
    var healthSamples: [HKQuantitySample] = []
    var showHealthPermissionRequest = false
    var showNotificationRequest = false
    
    private enum CodingKeys: String, CodingKey {
        case target, timeToDrink, timeToDrinkNotification, notificationInterval, showHealthPermissionRequest, showNotificationRequest
    }

    init() { }
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(Model.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try Model(json: data)
    }
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    mutating func restoreDefaults() {
        target = 3000
        timeToDrink = false
        timeToDrinkNotification = false
        notificationInterval = 3600
        showHealthPermissionRequest = false
        showNotificationRequest = false
    }
    
    mutating func updateHealthRecords(with samples: [HKQuantitySample]) {
        healthSamples = samples
    }
}
