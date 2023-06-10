//
//  WaterData.swift
//  DiateryWaterData
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftData
import Foundation

@Model public class WaterData {
    public var badge: Int
    
    public init() {
        self.badge = 1
    }
    
//    static let container = try! ModelContainer(for: schema, configurations: [.init(inMemory: DataGenerationOptions.inMemoryPersistence)])
    
    static let schema = SwiftData.Schema([
        WaterData.self
    ])
}
