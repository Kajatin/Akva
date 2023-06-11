//
//  WaterData.swift
//  DiateryWaterData
//
//  Created by Roland Kajatin on 10/06/2023.
//

import OSLog
import SwiftData
import HealthKit
import Foundation

private let logger = Logger(subsystem: "DiateryWaterData", category: "General")

@Model public class WaterData {
    public var target: Double = 3000
    public var timeToDrink: Bool = true
    public var lastSyncDate: Date? = nil
    @Transient public var error: Error? = nil
    @Transient public var samples: [HKQuantitySample] = []
    
    private let syncIntervalMinutes: Int = 30
    
    /// Determines whether data should be synced from Apple Health.
    @Transient public var requiresSyncing: Bool {
        guard let lastSyncDate = lastSyncDate else {
            return true
        }
        let oneHourAgo = Calendar.current.date(byAdding: .minute, value: -syncIntervalMinutes, to: Date())!
        return lastSyncDate < oneHourAgo
    }

    public init() {
        logger.info("Creating WaterData model")
    }

    private func syncDataFromHealth(modelContext: ModelContext) {
        if (!requiresSyncing) {
            logger.info("Water data is already up-to-date")
            return
        }

        logger.info("Syncing water data from Apple Health")
        HealthStoreManager.shared.loadWaterData { samples in
            self.samples = samples
            self.lastSyncDate = .now
            logger.info("Successfully synced \(self.samples.count) water records")
        } onError: { error in
            self.error = error
            logger.error("Error syncing water records: \(String(describing: error))")
        }
    }

    private static func instance(with modelContext: ModelContext) -> WaterData {
        if let result = try! modelContext.fetch(FetchDescriptor<WaterData>()).first {
            return result
        } else {
            let instance = WaterData()
            modelContext.insert(instance)
            return instance
        }
    }

    public static func syncWaterDataFromHealth(modelContext: ModelContext) {
        let instance = instance(with: modelContext)
        instance.syncDataFromHealth(modelContext: modelContext)
    }
}

public extension WaterData {
    static let container = try! ModelContainer(for: schema, configurations: [.init(inMemory: WaterDataOptions.inMemoryPersistence)])

    static let schema = SwiftData.Schema([
        WaterData.self
    ])
}
