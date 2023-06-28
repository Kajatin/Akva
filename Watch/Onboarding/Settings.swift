//
//  Settings.swift
//  Akva Watch App
//
//  Created by Roland Kajatin on 27/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct Settings: View {
    @Query private var waterData: [WaterData]
    @State private var waitedToShowIssue = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(StorageKeys.onboardingNeeded) var onboardingNeeded = true
    @Bindable private var notificationManager = NotificationManager.shared
    
    var body: some View {
        Group {
            if let data = waterData.first {
                Form {
                    Section(header: Text("General")) {
                        NavigationLink(destination: TargetSettingView(data: data)) {
                            HStack {
                                Text("Target")
                                Spacer()
                                Text("\(data.target.formatted()) mL")
                            }
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
                    
                    Button {
                        onboardingNeeded = false
                    } label: {
                        Text("Get Started")
                            .font(.headline)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .listRowBackground(Color.clear)
                }
            } else {
                ContentUnavailableView {
                    Label {
                        Text(verbatim: "Failed to load app content")
                    } icon: {
                        Image(systemName: "xmark")
                    }
                }
                .opacity(waitedToShowIssue ? 1 : 0)
                .task {
                    Task {
                        try await Task.sleep(for: .seconds(1))
                        waitedToShowIssue = true
                    }
                }
            }
        }
        .padding(.horizontal)
        .containerBackground(.white.gradient, for: .navigation)
        .navigationTitle("Settings")
    }
}

struct TargetSettingView: View {
    @Bindable var data: WaterData
    public init(data: WaterData) {
        self._data = Bindable(wrappedValue: data)
    }
    
    private var volumes: [Double] = Array(stride(from: 500.0, through: 5000.0, by: 100.0))
    
    var body: some View {
        Picker("", selection: $data.target) {
            ForEach(volumes, id:\.self) { volume in
                Text("\(volume.formatted()) mL")
            }
        }
        .pickerStyle(.automatic)
        .containerBackground(.white.gradient, for: .navigation)
        .navigationTitle("Target")
    }
}

#Preview {
    Settings()
        .waterDataContainer(inMemory: true)
}
