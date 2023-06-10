//
//  ContentView.swift
//  Akva
//
//  Created by Roland Kajatin on 10/09/2022.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct ContentView: View {
    @State private var selection: AppScreen? = .today
    @Environment(\.prefersTabNavigation) private var prefersTabNavigation

    var body: some View {
        if prefersTabNavigation {
            AppTabView(selection: $selection)
        } else {
            NavigationSplitView {
                AppSidebarList(selection: $selection)
            } detail: {
                AppDetailColumn(screen: selection)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let viewModel = ViewModel()

    static var previews: some View {
        ContentView()
            .environmentObject(viewModel)
            .waterDataContainer()
    }
}
