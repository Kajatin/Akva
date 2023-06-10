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
    @Environment(\.scenePhase) var scenePhase
    @AppStorage(StorageKeys.onboardingNeeded) var onboardingNeeded = true

    var body: some Scene {
        WindowGroup {
            Group {
                if (onboardingNeeded) {
                    EmptyView()
                } else {
                    ContentView()
                        .environmentObject(viewModel)
                        .waterDataContainer()
                }
            }
            .sheet(isPresented: $onboardingNeeded) {
                OnboardingFlow()
            }
        }
        .onChange(of: scenePhase) { old, new in
            switch new {
            case .background:
                break
            case .active:
                viewModel.refresh()
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
}
