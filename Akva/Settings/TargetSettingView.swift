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
    @Bindable var data: WaterData
    public init(data: WaterData) {
        self._data = Bindable(wrappedValue: data)
    }

    private var volumes: [Double] = Array(stride(from: 500.0, through: 5000.0, by: 100.0))

    var body: some View {
        Form {
            Section("Target water intake") {
                Picker("Target", selection: $data.target) {
                    ForEach(volumes, id:\.self) { volume in
                        Text("\(volume.formatted()) mL")
                    }
                }
                .pickerStyle(.wheel)
            }
        }
        .navigationTitle("Settings")
    }
}

//#Preview {
//    TargetSettingView()
//        .waterDataContainer(inMemory: true)
//}
