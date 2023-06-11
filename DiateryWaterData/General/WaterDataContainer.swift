//
//  WaterDataContainer.swift
//  DiateryWaterData
//
//  Created by Roland Kajatin on 10/06/2023.
//

import OSLog
import SwiftUI
import SwiftData

private let logger = Logger(subsystem: "DiateryWaterData", category: "General")

struct WaterDataContainerViewModifier: ViewModifier {
    let container: ModelContainer
    
    init(inMemory: Bool) {
        container = try! ModelContainer(for: WaterData.schema, configurations: [ModelConfiguration(inMemory: inMemory)])
    }
    
    func body(content: Content) -> some View {
        content
            .syncData()
            .modelContainer(container)
    }
}

struct SyncDataViewModifier: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var modelContext
    
    func body(content: Content) -> some View {
        content.onAppear {
            WaterData.syncWaterDataFromHealth(modelContext: modelContext)
        }.onChange(of: scenePhase) { old, new in
            switch new {
            case .active:
                WaterData.syncWaterDataFromHealth(modelContext: modelContext)
            default:
                break
            }
        }
    }
}

public extension View {
    func waterDataContainer(inMemory: Bool = WaterDataOptions.inMemoryPersistence) -> some View {
        modifier(WaterDataContainerViewModifier(inMemory: inMemory))
    }
}

fileprivate extension View {
    func syncData() -> some View {
        modifier(SyncDataViewModifier())
    }
}
