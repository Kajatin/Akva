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
        NavigationStack {
            VStack {
                Spacer()
                CircularProgressBar(radius: 130, target: data.target, progress: data.progress, progressNormalized: data.progressNormalized)
            }
            .tint(Color.accentColor)
            .containerBackground(Color.accentColor.gradient, for: .tabView)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showRegisterSheet = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showRegisterSheet) {
                RegisterHydration(data: data)
            }
            .navigationTitle("Overview")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    Overview()
//}
