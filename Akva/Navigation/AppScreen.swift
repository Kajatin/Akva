//
//  AppScreen.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import DiateryWaterData

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case today
    case history
    case account
    
    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .today:
            Label("Today", systemImage: "house")
        case .history:
            Label("History", systemImage: "calendar")
        case .account:
            Label("Account", systemImage: "person.crop.circle")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .today:
            TodayNavigationStack()
        case .history:
            HistoryNavigationStack()
        case .account:
            AccountNavigationStack()
        }
    }
    
    var badge: Int {
        switch self {
        case .today:
            NotificationManager.shared.badge
        default:
            0
        }
    }
}
