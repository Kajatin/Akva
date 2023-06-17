//
//  AllDrinkData.swift
//  Aqua
//
//  Created by Roland Kajatin on 01/10/2022.
//

import SwiftUI
import SwiftData
import HealthKit
import DiateryWaterData

struct AllDrinkData: View {
    @Query private var waterData: [WaterData]
    @Environment(\.presentationMode) var presentationMode
    
    func removeHealthRecord(at offsets: IndexSet) {
//        numbers.remove(atOffsets: offsets)
    }
    
    var body: some View {
        if let data = waterData.first {
            List {
                ForEach(data.samples.reversed(), id: \.self) { record in
                    let volume = record.quantity.doubleValue(for: HKUnit.literUnit(with: .milli))
                    let date = record.endDate
                    
                    HStack {
                        Text("\(volume.formatted()) mL")
                        Spacer()
                        Text("\(date.formatted())")
                    }
                }
                .onDelete(perform: removeHealthRecord)
            }
            .toolbar {
                EditButton()
            }
            .navigationTitle("Water records")
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}

#Preview {
    AllDrinkData()
        .waterDataContainer(inMemory: true)
}
