//
//  Welcome.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI

struct Welcome: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @Environment(\.colorScheme) var colorScheme
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("Hi 👋")
                .font(.title)
                .bold()
                .padding(.top, 25)
            Text("Akva helps you reach your daily water intake goals with smart reminders and tracking of how much you drink.")
                .font(.title3)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.fixed(64)),
                    GridItem(.flexible())
                ], spacing: 30) {
                    VStack {
                        Image("Icon - Apple Health")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64)
                        Spacer()
                    }
                    HStack {
                        Text("Akva synchronizes your diatery water intake information with Apple Health to consolidate your health information in one place.")
                            .padding(.leading)
                        Spacer()
                    }
                    
                    VStack {
                        Image(systemName: "bell.badge.fill")
                            .frame(width: 64, height: 64)
                            .foregroundColor(.white)
                            .scaleEffect(1.8)
                            .background(Color(red: 234/255, green: 79/255, blue: 61/255))
                            .cornerRadius(12)
                        Spacer()
                    }
                    HStack {
                        Text("Akva relies on system notifications to remind you when it is time to take a sip.")
                            .padding(.leading)
                        Spacer()
                    }
                    
                    VStack {
                        Image(systemName: "hand.raised.fill")
                            .frame(width: 64, height: 64)
                            .foregroundColor(.white)
                            .scaleEffect(1.8)
                            .background(Color(red: 55/255, green: 118/255, blue: 246/255))
                            .cornerRadius(12)
                        Spacer()
                    }
                    HStack {
                        Text("Akva never shares any of your information with third parties. Your data never leaves your device, preserving your privacy at all times.")
                            .padding(.leading)
                        Spacer()
                    }
                }
            }
            
            Button {
                onboardingSteps.append(.healthKitPermissions)
            } label: {
                Text("Continue")
                    .font(.headline)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
        }
        .padding(.all)
        .background(colorScheme == .dark ? .clear : .gray.opacity(0.15))
        .navigationTitle("Hi")
    }
}

struct Welcome_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        Welcome(onboardingSteps: $path)
    }
}
