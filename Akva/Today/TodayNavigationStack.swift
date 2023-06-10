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

struct TodayNavigationStack_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        TodayNavigationStack()
            .environmentObject(viewModel)
            .waterDataContainer()
    }
}
