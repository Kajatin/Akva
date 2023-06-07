//
//  WarningsView.swift
//  Aqua
//
//  Created by Roland Kajatin on 30/09/2022.
//

import SwiftUI

struct WarningsView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        if viewModel.showTimeToDrinkWarning() || viewModel.showOffTrackWarning() {
            VStack(alignment: .leading) {
                Text("Alerts")
                    .font(.title2)
                    .bold()
                VStack(spacing: 15) {
                    if viewModel.showTimeToDrinkWarning() {
                        TimeToDrink()
                    }
                    if viewModel.showOffTrackWarning() {
                        OffTrackToCompleteGoal()
                    }
                }
                .labelStyle(AquaWarningLabelStyle())
            }
        }
    }
}

struct TimeToDrink: View {
    @EnvironmentObject var viewModel: ViewModel
    
    private let volumeAmounts = [100, 200, 250, 300]
    
    @State private var selectedVolume: Int = 200
    @State private var isPresentingConfirm: Bool = false
    
    var body: some View {
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
                        viewModel.registerDrink(volume: Double(selectedVolume), date: Date.now)
                    }
                }
            }
        }
    }
}

struct OffTrackToCompleteGoal: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        GroupBox(label: Label("Important", systemImage: "exclamationmark.triangle")) {
            VStack(alignment: .leading) {
                Text("You are off track to reach your target")
                    .font(.headline)
                    .bold()
                    .padding(.top, 1)
                
                Divider()
                
                VStack(alignment: .leading) {
                    ConsumptionBar(consumption: viewModel.projected, ratio: CGFloat(viewModel.progress / viewModel.target), fill: Color.accentColor, legend: "Projected")
                    ConsumptionBar(consumption: viewModel.target, ratio: 1, fill: Color.secondary, legend: "Target")
                }
            }
        }
    }
}

struct AquaWarningLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label(configuration)
            .foregroundColor(.accentColor)
    }
}

struct WarningsView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        WarningsView().environmentObject(viewModel)
    }
}
