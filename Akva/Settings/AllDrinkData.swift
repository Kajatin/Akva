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
    var samples: [HKQuantitySample]
    @Environment(\.presentationMode) var presentationMode
    
    func removeHealthRecord(at offsets: IndexSet) {
//        numbers.remove(atOffsets: offsets)
    }
    
    var body: some View {
        List {
            ForEach(samples.reversed(), id: \.self) { record in
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
    }
}

#Preview {
    ModelPreview { (model: WaterData) in
        AllDrinkData(samples: model.samples)
    }
}
