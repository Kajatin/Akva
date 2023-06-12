//
//  WarningsView.swift
//  Aqua
//
//  Created by Roland Kajatin on 30/09/2022.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct WarningsView: View {
    @Query private var waterData: [WaterData]
    
    var body: some View {
        if let data = waterData.first {
            if data.showTimeToDrinkWarning || data.showOffTrackWarning {
                VStack(alignment: .leading) {
                    Text("Alerts")
                        .font(.title2)
                        .bold()
                    VStack(spacing: 15) {
                        if data.showTimeToDrinkWarning {
                            TimeToDrink()
                        }
                        if data.showOffTrackWarning {
                            OffTrackToCompleteGoal()
                        }
                    }
                    .labelStyle(AquaWarningLabelStyle())
                }
            }
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}

struct TimeToDrink: View {
    @Query private var waterData: [WaterData]
    
    private let volumeAmounts = [100, 200, 250, 300]
    
    @State private var selectedVolume: Int = 200
    @State private var isPresentingConfirm: Bool = false
    
    var body: some View {
        if let data = waterData.first {
            GroupBox(label: Label("Important", systemImage: "exclamationmark.triangle")) {
                VStack(alignment: .leading) {
                    Text("You have not drunk in a long time")
                        .font(.headline)
                        .bold()
                        .padding(.top, 1)
                    
                    Divider()
                    
                    Picker("Volume", selection: $selectedVolume) {
                        ForEach(volumeAmounts, id: \.self) { volume in
                            Text("\(volume)")
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 4)
                    
                    Button {
                        isPresentingConfirm = true
                    } label: {
                        Text("Add drink")
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 2)
                    .confirmationDialog("Do you want to add \(selectedVolume) mL?", isPresented: $isPresentingConfirm, titleVisibility: .visible) {
                        Button("Add drink") {
                            data.addConsumption(quantity: Double(selectedVolume), date: .now)
                        }
                    }
                }
            }
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}

struct OffTrackToCompleteGoal: View {
    @Query private var waterData: [WaterData]
    
    var body: some View {
        if let data = waterData.first {
            GroupBox(label: Label("Important", systemImage: "exclamationmark.triangle")) {
                VStack(alignment: .leading) {
                    Text("You are off track to reach your target")
                        .font(.headline)
                        .bold()
                        .padding(.top, 1)
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        ConsumptionBar(consumption: data.projected, ratio: CGFloat(data.progress / data.target), fill: Color.accentColor, legend: "Projected")
                        ConsumptionBar(consumption: data.target, ratio: 1, fill: Color.secondary, legend: "Target")
                    }
                }
            }
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}

struct AquaWarningLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label(configuration)
            .foregroundColor(.accentColor)
    }
}

#Preview {
    WarningsView()
        .waterDataContainer(inMemory: true)
}
