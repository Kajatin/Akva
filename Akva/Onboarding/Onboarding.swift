//
//  Onboarding.swift
//  Akva
//
//  Created by Roland Kajatin on 11/06/2023.
//

import SwiftUI

struct OnboardingViewModifier: ViewModifier {
    @AppStorage(StorageKeys.onboardingNeeded) var onboardingNeeded = true
    
    func body(content: Content) -> some View {
        Group {
            if (onboardingNeeded) {
                EmptyView()
            } else {
                content
            }
        }
        .sheet(isPresented: $onboardingNeeded) {
            OnboardingFlow()
        }
    }
}

extension View {
    func onboarding() -> some View {
        modifier(OnboardingViewModifier())
    }
}
