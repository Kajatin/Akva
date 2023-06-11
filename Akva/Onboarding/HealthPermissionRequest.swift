//
//  HealthPermissionRequest.swift
//  Aqua
//
//  Created by Roland Kajatin on 01/10/2022.
//

import SwiftUI
import DiateryWaterData

struct HealthPermissionRequest: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @Environment(\.colorScheme) var colorScheme
    @State var healthKitProcessing = false
    @State var showDeniedAlert = false
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 25) {
                Image("Icon - Apple Health")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64)
                Text("Automatically sync your water intake records with Apple Health")
                    .font(.title)
                    .bold()
                Text("Using Akva with the Apple Health app enables you to consolidate your diatery water intake information in one place. Akva shows you intake trends and notifications to help you reach your goals.")
            }
            
            Spacer()
            
            Button {
                Task {
                    if (!HealthStoreManager.shared.isHealthKitAuthorized) {
                        do {
                            healthKitProcessing = true
                            try await HealthStoreManager.shared.requestAuthorization()
                        } catch {
                            print("Could not request HealthKit permissions.")
                        }
                        
                        healthKitProcessing = false
                    }
                    
                    if (HealthStoreManager.shared.isHealthKitAuthorized) {
                        onboardingSteps.append(.notificationsPermissions)
                    } else {
                        showDeniedAlert = true
                    }
                }
            } label: {
                Group {
                    if healthKitProcessing {
                        ProgressView()
                    } else {
                        Text("Sync Health Data")
                    }
                }
                .font(.headline)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
        }
        .padding(.all)
        .background(colorScheme == .dark ? .clear : .gray.opacity(0.15))
        .navigationTitle("Apple Health")
        .navigationBarBackButtonHidden(healthKitProcessing)
        .alert("Akva will not function properly without Apple Health. You may grant access later in Settings.", isPresented: $showDeniedAlert) {
            Button {
                onboardingSteps.append(.notificationsPermissions)
            } label: {
                Text("OK")
            }
        }
    }
}

struct HealthPermissionRequest_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        HealthPermissionRequest(onboardingSteps: $path)
    }
}
