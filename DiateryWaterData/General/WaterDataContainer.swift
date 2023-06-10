//
//  WaterDataContainer.swift
//  DiateryWaterData
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData

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
    @Environment(\.modelContext) private var modelContext
    
    func body(content: Content) -> some View {
        content.onAppear {
            // TODO: sync data from health
//            DataGeneration.generateAllData(modelContext: modelContext)
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
