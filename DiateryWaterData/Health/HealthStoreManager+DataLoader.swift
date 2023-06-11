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

extension HealthStoreManager {
    internal func loadWaterData(execute: @escaping ([HKQuantitySample]) -> Void, onError: @escaping (Error?) -> Void) {
        if (authorizationStatus == .notDetermined) {
            logger.error("Cannot load data because authorization has not been granted")
            onError(HKError(HKError(.errorAuthorizationNotDetermined).code))
            return
        }

        if (authorizationStatus == .sharingDenied) {
            logger.error("Cannot load data because authorization has been denied")
            onError(HKError(HKError(.errorAuthorizationDenied).code))
            return
        }

//        let last24hPredicate = HKQuery.predicateForSamples(withStart: Date().oneDayAgo, end: Date(), options: .strictEndDate)
        
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

            logger.trace("Loaded \(samples.count) water records")
            execute(samples)
        }

        healthStore.execute(waterQuery)
    }
}
