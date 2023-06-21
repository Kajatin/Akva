//
//  RegisterHydration.swift
//  Akva Watch App
//
//  Created by Roland Kajatin on 15/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct RegisterHydration: View {
    var addConsumption: (Double, Date) -> Void
    @State private var volume: Double = 250
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(Int(volume))")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blue)
                    Text("mL")
                        .font(.body)
                }
                HStack {
                    Button {
                        volume = max(volume-50, 0)
                    } label: {
                        Image(systemName: "minus")
                    }
                    Spacer()
                    Button {
                        volume = min(volume+50, 1000)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    addConsumption(volume, .now)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("Save", systemImage: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    ModelPreview { (model: WaterData) in
        RegisterHydration(addConsumption: model.addConsumption)
    }
}
