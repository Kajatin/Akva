//
//  Settings.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
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
                        Toggle(isOn: $notificationManager.soundEnabled) {
                            Text("Enable Sound")
                        }
                        Toggle(isOn: $notificationManager.notificationEnabled) {
                            Text("Enable Notifications")
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
        .navigationTitle("Settings")
    }
}

#Preview {
    Settings()
        .waterDataContainer(inMemory: true)
}
