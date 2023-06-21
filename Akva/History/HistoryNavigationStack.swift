//
//  HistoryNavigationStack.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct HistoryNavigationStack: View {
    @Query private var waterData: [WaterData]
    @State private var waitedToShowIssue = false
    
    var body: some View {
        if let data = waterData.first {
            NavigationStack {
                History(normalizedProgress: data.normalizedProgress)
            }
            .navigationTitle("History")
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
    HistoryNavigationStack()
        .waterDataContainer(inMemory: true)
}
