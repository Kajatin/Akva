//
//  AquaApp.swift
//  Aqua
//
//  Created by Roland Kajatin on 10/09/2022.
//

import SwiftUI
import SwiftData
import DiateryWaterData

@main
struct AkvaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onboarding()
                .waterDataContainer()
        }
    }
}
