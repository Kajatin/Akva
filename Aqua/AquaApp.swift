//
//  AquaApp.swift
//  Aqua
//
//  Created by Roland Kajatin on 10/09/2022.
//

import SwiftUI

@main
struct AquaApp: App {
    let viewModel = ViewModel()
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }.onChange(of: scenePhase) { phase in
            switch phase {
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
