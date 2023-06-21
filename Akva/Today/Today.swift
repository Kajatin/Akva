//
//  Today.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct Today: View {
    var data: WaterData
    @State private var showAddDrinkSheet = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                CircularProgressBar(radius: 125, target: data.target, progress: data.progress, progressNormalized: data.progressNormalized)
                    .padding(.top, 40)
                WarningsView(data: data)
                StatsView(data: data)
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddDrinkSheet.toggle()
                    } label: {
                        ZStack {
                            Image(systemName: "plus")
                            if (NotificationManager.shared.timeToDrink) {
                                Image(systemName: "circle.fill")
                                    .offset(x: 25, y: -25)
                                    .scaleEffect(0.45)
                            }
                        }
                        .foregroundColor(.accentColor)
                        .animation(.spring(), value: NotificationManager.shared.timeToDrink)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddDrinkSheet) {
            RegisterWaterIntake(addConsumption: data.addConsumption)
        }
    }
}
    
#Preview {
    ModelPreview { model in
        Today(data: model)
    }
}
