//
//  HealthStoreManager+DataWriter.swift
//  
//
//  Created by Roland Kajatin on 11/06/2023.
//

import OSLog
import HealthKit
import Foundation

private let logger = Logger(subsystem: "DiateryWaterData", category: "Health")

extension HealthStoreManager {
    internal func createWaterSample(quantity: Double, date: Date) -> HKQuantitySample {
        let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: quantity)
        return HKQuantitySample(type: diateryWaterType, quantity: waterQuantity, start: date, end: date)
    }
    
    internal func writeWaterSample(_ sample: HKQuantitySample, completion: @escaping (Bool, Error?) -> Void) {
        if (authorizationStatus == .notDetermined) {
            logger.error("Cannot save data because authorization has not been granted")
            completion(false, HKError(HKError(.errorAuthorizationNotDetermined).code))
            return
        }
        
        if (authorizationStatus == .sharingDenied) {
            logger.error("Cannot save data because authorization has been denied")
            completion(false, HKError(HKError(.errorAuthorizationDenied).code))
            return
        }
        
        logger.trace("Saving sample to Apple Health")
        healthStore.save(sample, withCompletion: completion)
    }
}

