//
//  AppDetailColumn.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct AppDetailColumn: View {
    var screen: AppScreen?
    
    var body: some View {
        Group {
            if let screen {
                screen.destination
            } else {
                ContentUnavailableView("Content unavailable", systemImage: "xmark.circle", description: Text("Pick something from the list."))
            }
        }
#if os(macOS)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
#endif
    }
}

#Preview {
    AppDetailColumn()
        .waterDataContainer(inMemory: true)
}
