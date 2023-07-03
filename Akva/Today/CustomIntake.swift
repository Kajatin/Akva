//
//  CustomIntake.swift
//  Akva
//
//  Created by Roland Kajatin on 03/07/2023.
//

import SwiftUI

struct CustomIntake: View {
    @State var customVolume: String = ""
    
    @Binding var volumeAmounts: [Double]
    @Binding var selectedVolume: Double
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter Custom Volume", text: $customVolume)
                    .keyboardType(.decimalPad)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if let customVolumeDouble = Double(customVolume) {
                            selectedVolume = customVolumeDouble
                            volumeAmounts.append(customVolumeDouble)
                        }
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
            .navigationTitle("Custom Volume")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    CustomIntake()
//}
