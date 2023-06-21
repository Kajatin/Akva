//
//  RegisterWaterIntake.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct RegisterWaterIntake: View {
    var addConsumption: (Double, Date) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    private let volumeAmounts: [Double] = [100, 150, 200, 250, 300, 350]
    @State private var selectedVolume: Double = 200
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Volume", selection: $selectedVolume) {
                    ForEach(volumeAmounts, id: \.self) { volume in
                        Text("\(volume.formatted())")
                    }
                }
                .pickerStyle(.inline)
                
                Section("Date") {
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    DatePicker(
                        "Time",
                        selection: $date,
                        displayedComponents: [.hourAndMinute]
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        addConsumption(selectedVolume, date)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Add")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

#Preview {
    ModelPreview { (model: WaterData) in
        RegisterWaterIntake(addConsumption: model.addConsumption)
    }
}
