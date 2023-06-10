//
//  Settings.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI

struct Settings: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(StorageKeys.onboardingNeeded) var onboardingNeeded = true
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("Settings")
            
            Spacer()
            
            Button {
                onboardingNeeded = false
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
        }
        .padding(.all)
        .background(colorScheme == .dark ? .clear : .gray.opacity(0.15))
        .navigationTitle("Settings")
    }
}

#Preview {
    Settings()
}
