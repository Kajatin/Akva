//
//  TargetSettingView.swift
//  Aqua
//
//  Created by Roland Kajatin on 01/10/2022.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct TargetSettingView: View {
    @Query private var waterData: [WaterData]
    // TODO: this is temporary because the $data.target binding wasn't compiling
    @State private var target: Double = 3000

    private var volumes: [Double] = Array(stride(from: 500.0, through: 5000.0, by: 100.0))

    var body: some View {
        if let data = waterData.first {
            Form {
                Section("Target water intake") {
                    Picker("Target", selection: $target) {
                        ForEach(volumes, id:\.self) { volume in
                            Text("\(volume.formatted()) mL")
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .navigationTitle("Settings")
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}

#Preview {
    TargetSettingView()
        .waterDataContainer(inMemory: true)
}
