//
//  AccountNavigationStack.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct SettingsNavigationStack: View {
    @Query private var waterData: [WaterData]
    @State private var waitedToShowIssue = false
    
    var body: some View {
        if let data = waterData.first {
            NavigationStack {
                SettingsView(data: data)
            }
            .navigationTitle("Settings")
        } else {
            ContentUnavailableView {
                Label {
                    Text(verbatim: "Failed to load app content")
                } icon: {
                    Image(systemName: "xmark")
                }
            }
            .opacity(waitedToShowIssue ? 1 : 0)
            .task {
                Task {
                    try await Task.sleep(for: .seconds(1))
                    waitedToShowIssue = true
                }
            }
        }
    }
}

#Preview {
    SettingsNavigationStack()
        .waterDataContainer(inMemory: true)
}

