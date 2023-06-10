//
//  AppSidebarList.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI

struct AppSidebarList: View {
    @Binding var selection: AppScreen?
    
    var body: some View {
        List(AppScreen.allCases, selection: $selection) { screen in
            NavigationLink(value: screen) {
                screen.label
            }
        }
        .navigationTitle("Akva")
    }
}

#Preview {
    NavigationSplitView {
        AppSidebarList(selection: .constant(.today))
    } detail: {
        Text(verbatim: "Check out that sidebar!")
    }
    .waterDataContainer(inMemory: true)
}
