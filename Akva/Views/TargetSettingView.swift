//
//  TargetSettingView.swift
//  Aqua
//
//  Created by Roland Kajatin on 01/10/2022.
//

import SwiftUI

struct TargetSettingView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    private var volumes: [Double] = Array(stride(from: 500.0, through: 5000.0, by: 100.0))
    
    var body: some View {
        Form {
            Section("Target water intake") {
                Picker("Target", selection: $viewModel.target) {
                    ForEach(volumes, id:\.self) { volume in
                        Text("\(volume.formatted()) mL")
                    }
                }
                .pickerStyle(.wheel)
            }
        }
        .navigationTitle("Settings")
    }
}

struct TargetSettingView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        TargetSettingView().environmentObject(viewModel)
    }
}
