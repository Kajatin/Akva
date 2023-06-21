//
//  Account.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct SettingsView: View {
    var data: WaterData
    @Bindable private var notificationManager = NotificationManager.shared

    var body: some View {
        Form {
            Section(header: Text("General")) {
                NavigationLink(destination: TargetSettingView(data: data)) {
                    HStack {
                        Text("Target")
                        Spacer()
                        Text("\(data.target.formatted()) mL")
                    }
                }
                
                NavigationLink(destination: AllDrinkData(samples: data.samples)) {
                    Text("Show All Data")
                }
            }
            
            Section(header: Text("Notification preferences")) {
                Toggle(isOn: $notificationManager.notificationEnabled) {
                    Text("Enable Notifications")
                }
                Toggle(isOn: $notificationManager.soundEnabled) {
                    Text("Enable Sound")
                }
            }
            
            Section(header: Text("Information")) {
                NavigationLink(destination: About()) {
                    Text("About App")
                }
                NavigationLink(destination: PrivacyPolicy()) {
                    Text("Privacy Policy")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    ModelPreview { model in
        SettingsView(data: model)
    }
}
