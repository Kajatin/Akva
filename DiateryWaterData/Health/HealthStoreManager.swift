//
//  HealthStoreManager.swift
//
//
//  Created by Roland Kajatin on 08/06/2023.
//

import HealthKit
import Foundation

public class HealthStoreManager {
    public static let shared = HealthStoreManager()
    private(set) var authorizationStatus: HKAuthorizationStatus

    internal let healthStore: HKHealthStore
    internal let diateryWaterType: HKQuantityType

    private init() {
        precondition(HKHealthStore.isHealthDataAvailable(), "Healthkit is not available on this device")

        healthStore = HKHealthStore()

        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            fatalError("Diatery water HealthKit object type not available")
        }
        diateryWaterType = waterType
        authorizationStatus = healthStore.authorizationStatus(for: diateryWaterType)
    }

    public var isHealthKitAuthorized: Bool {
        authorizationStatus == .sharingAuthorized
    }

    public func requestAuthorization() async throws {
        let healthKitTypes = Set([diateryWaterType])
        try await healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes)
        self.authorizationStatus = self.healthStore.authorizationStatus(for: self.diateryWaterType)
    }
}
