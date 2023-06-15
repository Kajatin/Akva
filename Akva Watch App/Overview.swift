//
//  Overview.swift
//  Akva Watch App
//
//  Created by Roland Kajatin on 14/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct Overview: View {
    @Bindable var data: WaterData
    @State private var showRegisterSheet = false
    
    var body: some View {
        VStack {
            Text("\(data.progress)")
            Text("\(data.target)")
            Spacer()
        }
        .tint(.blue)
        .containerBackground(.blue.gradient, for: .tabView)
        .sheet(isPresented: $showRegisterSheet) {
            RegisterHydration(data: data)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    showRegisterSheet = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
    }
}

//#Preview {
//    Overview()
//}
