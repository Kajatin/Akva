//
//  TodayNavigationStack.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import DiateryWaterData

struct TodayNavigationStack: View {
    var body: some View {
        NavigationStack {
            Today()
                .navigationTitle("Today")
        }
    }
}

#Preview {
    TodayNavigationStack()
        .waterDataContainer(inMemory: true)
}
