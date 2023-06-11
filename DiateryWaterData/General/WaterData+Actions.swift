//
//  WaterData+Actions.swift
//
//  Created by Roland Kajatin on 11/06/2023.
//

import OSLog
import HealthKit
import Foundation

private let logger = Logger(subsystem: "DiateryWaterData", category: "General")

extension WaterData {
    public func addConsumption(quantity: Double, date: Date) {
        let sample = HealthStoreManager.shared.createWaterSample(quantity: quantity, date: date)
        HealthStoreManager.shared.writeWaterSample(sample) { success, error in
            if (success) {
                logger.info("Successfully added new water sample to Apple Health")
                self.samples.append(sample)
            } else {
                logger.error("Failed to add water sample to Apple Health: \(String(describing: error))")
            }
        }
    }
}
