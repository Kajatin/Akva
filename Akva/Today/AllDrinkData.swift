//
//  AllDrinkData.swift
//  Aqua
//
//  Created by Roland Kajatin on 01/10/2022.
//

import SwiftUI
import HealthKit

struct AllDrinkData: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    func removeHealthRecord(at offsets: IndexSet) {
//        numbers.remove(atOffsets: offsets)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.model.healthSamples.reversed(), id: \.self) { record in
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

struct AllDrinkData_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        AllDrinkData().environmentObject(viewModel)
    }
}
