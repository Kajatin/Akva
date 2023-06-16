//
//  AkvaWatchApp.swift
//  Akva Watch App
//
//  Created by Roland Kajatin on 14/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

@main
struct BackyardBirdsWatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .waterDataContainer()
        }
    }
}
