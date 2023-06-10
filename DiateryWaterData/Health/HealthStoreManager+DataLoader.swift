//
//  DiateryWaterData.swift
//
//
//  Created by Roland Kajatin on 10/06/2023.
//

import OSLog
import HealthKit
import Foundation

private let logger = Logger(subsystem: "DiateryWaterData", category: "Health")

extension HealthStoreManagerNew {
    public func loadWaterData(execute: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        if (authorizationStatus == .notDetermined) {
            onError(HKError(HKError(.errorAuthorizationNotDetermined).code))
            return
        }

        if (authorizationStatus == .sharingDenied) {
            onError(HKError(HKError(.errorAuthorizationDenied).code))
            return
        }

        let waterQuery = HKSampleQuery(
            sampleType: self.diateryWaterType,
            predicate: nil,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil) { (query, samples, error) in
            guard error == nil, let samples = samples as? [HKQuantitySample] else {
                logger.error("Error loading water data: \(String(describing: error))")
                onError(error)
                return
            }

            self.waterData = samples
            logger.info("Loaded \(samples.count) water records")
            execute()
        }

        healthStore.execute(waterQuery)
    }
}
