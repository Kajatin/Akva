//
//  OnboardingFlow.swift
//  Akva Watch App
//
//  Created by Roland Kajatin on 27/06/2023.
//

import SwiftUI

struct OnboardingFlow: View {
    enum Step: String, Codable {
        case healthKitPermissions
        case notificationsPermissions
        case settings
    }
    
    @State private var onboardingSteps: [Step] = []
    @AppStorage(StorageKeys.onboardingNeeded) var onboardingNeeded = true
    
    var body: some View {
        NavigationStack(path: $onboardingSteps) {
            Welcome(onboardingSteps: $onboardingSteps)
                .navigationDestination(for: Step.self) { onboardingStep in
                    switch onboardingStep {
                    case .healthKitPermissions:
                        HealthPermissionRequest(onboardingSteps: $onboardingSteps)
                    case .notificationsPermissions:
                        NotificationPermissionRequest(onboardingSteps: $onboardingSteps)
                    case .settings:
                        Settings()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled(onboardingNeeded)
    }
}

#Preview {
    OnboardingFlow()
}
