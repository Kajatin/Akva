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
//    @UIApplicationDelegateAdaptor()
    @AppStorage(StorageKeys.onboardingNeeded) var onboardingNeeded = true

    var body: some Scene {
        WindowGroup {
            ContentView()
                .waterDataContainer()
                .onboarding()
        }
    }
}
