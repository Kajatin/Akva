//
//  Welcome.swift
//  Akva Watch App
//
//  Created by Roland Kajatin on 27/06/2023.
//

import SwiftUI

struct Welcome: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @Environment(\.colorScheme) var colorScheme
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
    
    var body: some View {
        ScrollView {
            Text("Hi 👋")
                .font(.title2)
                .bold()
                .padding(.bottom)

            Text("Akva helps you reach your daily water intake goals with smart reminders and tracking of how much you drink.")
                .padding(.bottom)
            
            Button {
                onboardingSteps.append(.healthKitPermissions)
            } label: {
                Text("Continue")
                    .font(.headline)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Hi")
    }
}

struct Welcome_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        Welcome(onboardingSteps: $path)
    }
}
