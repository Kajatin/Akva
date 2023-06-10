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

struct HistoryNavigationStack_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        HistoryNavigationStack()
            .environmentObject(viewModel)
    }
}
