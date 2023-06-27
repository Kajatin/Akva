//
//  Settings.swift
//  Akva Watch App
//
//  Created by Roland Kajatin on 27/06/2023.
//

import SwiftUI

struct Settings: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(StorageKeys.onboardingNeeded) var onboardingNeeded = true
    
    var body: some View {
        ScrollView {
            Text("Settings")
                .padding(.bottom)

            Button {
                onboardingNeeded = false
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    Settings()
}
