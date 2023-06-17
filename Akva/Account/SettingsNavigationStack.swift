//
//  AccountNavigationStack.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI

struct SettingsNavigationStack: View {
    var body: some View {
        NavigationStack {
            SettingsView()
                .navigationTitle("Account")
        }
    }
}

#Preview {
    SettingsNavigationStack()
}
