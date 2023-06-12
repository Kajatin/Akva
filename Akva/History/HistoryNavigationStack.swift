//
//  HistoryNavigationStack.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI



struct HistoryNavigationStack: View {
    var body: some View {
        NavigationStack {
            History()
                .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryNavigationStack()
        .waterDataContainer(inMemory: true)
}
