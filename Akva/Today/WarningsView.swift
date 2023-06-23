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
    var data: WaterData

    var body: some View {
        if data.showTimeToDrinkWarning || data.showOffTrackWarning {
            VStack(alignment: .leading) {
                Text("Alerts")
                    .font(.title2)
                    .bold()
                VStack(spacing: 15) {
                    if data.showTimeToDrinkWarning {
                        TimeToDrink(addConsumption: data.addConsumption)
                    }
                    if data.showOffTrackWarning {
                        OffTrackToCompleteGoal(target: data.target, progress: data.progress, projected: data.projected)
                    }
                }
                .labelStyle(AkvaWarningLabelStyle())
            }
        }
    }
}

struct TimeToDrink: View {
    var addConsumption: (Double, Date) -> Void

    private let volumeAmounts = [100, 200, 250, 300]

    @State private var selectedVolume: Int = 200
    @State private var isPresentingConfirm: Bool = false

    var body: some View {
        GroupBox(label: Label("Important", systemImage: "exclamationmark.triangle")) {
            VStack(alignment: .leading) {
                Text("You haven't had a drink in a long time")
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
                        addConsumption(Double(selectedVolume), .now)
                    }
                }
            }
        }
    }
}

struct OffTrackToCompleteGoal: View {
    var target: Double
    var progress: Double
    var projected: Double

    var body: some View {
        GroupBox(label: Label("Important", systemImage: "exclamationmark.triangle")) {
            VStack(alignment: .leading) {
                Text("You are off track to reach your target")
                    .font(.headline)
                    .bold()
                    .padding(.top, 1)

                Divider()

                VStack(alignment: .leading) {
                    ConsumptionBar(consumption: projected, ratio: CGFloat(progress / target), fill: Color.accentColor, legend: "Projected")
                    ConsumptionBar(consumption: target, ratio: 1, fill: Color.secondary, legend: "Target")
                }
            }
        }
    }
}

struct AkvaWarningLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label(configuration)
            .foregroundColor(.accentColor)
    }
}

#Preview {
    ModelPreview { model in
        WarningsView(data: model)
    }
}
