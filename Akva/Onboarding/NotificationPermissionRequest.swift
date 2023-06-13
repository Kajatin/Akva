//
//  NotificationPermissionRequest.swift
//  Aqua
//
//  Created by Roland Kajatin on 08/10/2022.
//

import SwiftUI
import DiateryWaterData

struct NotificationPermissionRequest: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @Environment(\.colorScheme) var colorScheme
    @State var notificationsProcessing = false
    @State var showSkipAlert = false
    @State var showDeniedAlert = false
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 25) {
                Image(systemName: "bell.badge.fill")
                    .frame(width: 64, height: 64)
                    .foregroundColor(.white)
                    .scaleEffect(1.8)
                    .background(Color(red: 234/255, green: 79/255, blue: 61/255))
                    .cornerRadius(12)
                Text("Akva helps you stay hydrated using Notifications")
                    .font(.title)
                    .bold()
                Text("Using Akva with notifications enabled will help you stay hydrated. Akva sends you notifications when it is time to drink to help you meet your goals.")
            }
            
            Spacer()
            
            Button {
                Task {
                    if await (!NotificationManager.shared.isNotificationsAuthorized()) {
                        do {
                            notificationsProcessing = true
                            let _ = try await NotificationManager.shared.requestAuthorization()
                        } catch {
                            print("Could not request Notification permissions.")
                        }
                        
                        notificationsProcessing = false
                    }
                    
                    if await (NotificationManager.shared.isNotificationsAuthorized()) {
                        onboardingSteps.append(.settings)
                    } else {
                        showDeniedAlert = true
                    }
                }
            } label: {
                Group {
                    if notificationsProcessing {
                        ProgressView()
                    } else {
                        Text("Allow Notifications")
                    }
                }
                .font(.headline)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
            
            Button {
                showSkipAlert.toggle()
            } label: {
                Text("Skip")
            }
            .padding(.bottom)
        }
        .padding(.all)
        .background(colorScheme == .dark ? .clear : .gray.opacity(0.15))
        .navigationTitle("Notifications")
        .navigationBarBackButtonHidden(notificationsProcessing)
        .alert("Akva will not be able to remind you without notifications", isPresented: $showSkipAlert) {
            Button(role: .cancel) {
            } label: {
                Text("Cancel")
            }
            Button {
                onboardingSteps.append(.settings)
            } label: {
                Text("OK")
            }
        }
        .alert("You can always enable notifications from Settings in the future.", isPresented: $showDeniedAlert) {
            Button {
                onboardingSteps.append(.settings)
            } label: {
                Text("OK")
            }
        }
    }
}

struct NotificationPermissionRequest_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        NotificationPermissionRequest(onboardingSteps: $path)
    }
}
