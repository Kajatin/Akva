//
//  AquaApp.swift
//  Aqua
//
//  Created by Roland Kajatin on 10/09/2022.
//

import SwiftUI
import DiateryWaterData

@main
struct AkvaApp: App {
    let viewModel = ViewModel()
//    @UIApplicationDelegateAdaptor()
    @AppStorage(StorageKeys.onboardingNeeded) var onboardingNeeded = true

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .waterDataContainer()
                .onboarding()
        }
    }
}
