//
//  ContentView.swift
//  Akva Watch App
//
//  Created by Roland Kajatin on 10/01/2023.
//

import Charts
import SwiftUI
import SwiftData
import HealthKit
import DiateryWaterData

struct ContentView: View {
    @Query private var waterData: [WaterData]
    @State private var waitedToShowIssue = false
    
    var body: some View {
        if let data = waterData.first {
            TabView {
                Overview(data: data)
                Details(data: data)
            }
            .tabViewStyle(.verticalPage)
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
    ContentView()
        .waterDataContainer(inMemory: true)
}
