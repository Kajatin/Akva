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

// TODO: Logo which is just a drop of water

struct ContentView: View {
    @Query private var waterData: [WaterData]
    @State private var selectedTab: Int = 2
    
    var body: some View {
        if let data = waterData.first {
            TabView {
                Overview(data: data)
                Details(waterData: data)
            }
            .tabViewStyle(.verticalPage)
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}
    
#Preview {
    ContentView()
        .waterDataContainer(inMemory: true)
}
