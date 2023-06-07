//
//  HealthStoreManager.swift
//  Aqua
//
//  Created by Roland Kajatin on 01/10/2022.
//

import Foundation
import HealthKit

class HealthStoreManager {
    private let healthStore: HKHealthStore
    private let diateryWaterType: HKQuantityType
    private(set) var waterRecords: [HKQuantitySample] = []
    
    init() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        
        healthStore = HKHealthStore()
        
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            fatalError("Diatery water HealthKit object type not available")
        }
        diateryWaterType = waterType
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let healthTypes = Set([diateryWaterType])
        
        healthStore.requestAuthorization(toShare: healthTypes, read: healthTypes, completion: completion)
    }
    
    func isAuthorization(_ state: HKAuthorizationStatus) -> Bool {
        return healthStore.authorizationStatus(for: diateryWaterType) == state
    }
    
    func readWater(execute: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        if isAuthorization(.notDetermined) {
            onError(HKError(HKError(.errorAuthorizationNotDetermined).code))
            return
        }
        
        if isAuthorization(.sharingDenied) {
            onError(HKError(HKError(.errorAuthorizationDenied).code))
            return
        }
        
//        let last24hPredicate = HKQuery.predicateForSamples(withStart: Date().oneDayAgo, end: Date(), options: .strictEndDate)
        let waterQuery = HKSampleQuery(sampleType: diateryWaterType,
                                       predicate: nil,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) {
            (query, samples, error) in
            
            guard error == nil, let samples = samples as? [HKQuantitySample] else {
                onError(error)
                return
            }
            
            self.waterRecords = samples
            
            DispatchQueue.main.async(execute: execute)
        }
        
        healthStore.execute(waterQuery)
    }
    
    func writeWaterSample(_ sample: HKQuantitySample, completion: @escaping (Bool, Error?) -> Void) {
        self.waterRecords.append(sample)
        healthStore.save(sample, withCompletion: completion)
    }
    
    func generateQuantitySample(quantity: Double, date: Date) -> HKQuantitySample {
        let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: quantity)
        return HKQuantitySample(type: diateryWaterType, quantity: waterQuantity, start: date, end: date)
    }
    
}
