//
//  AppTabView.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI

struct AppTabView: View {
    @Binding var selection: AppScreen?
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .badge(screen.badge)
                    .tabItem { screen.label }
            }
        }
    }
}
