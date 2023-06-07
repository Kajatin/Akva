//
//  NotificationPermissionRequest.swift
//  Aqua
//
//  Created by Roland Kajatin on 08/10/2022.
//

import SwiftUI

struct NotificationPermissionRequest: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showSkipAlert = false
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 25) {
                Image(systemName: "bell.badge.fill")
                    .frame(width: 64, height: 64)
                    .foregroundColor(.white)
                    .scaleEffect(1.8)
                    .background(Color(red: 234/255, green: 79/255, blue: 61/255))
                    .cornerRadius(12)
                Text("Aqua helps you stay hydrated using Notifications")
                    .font(.title)
                    .bold()
                Text("Use Aqua with notifications enabled will help you stay hydrated. Aqua presents you notifications when it's time to drink to ensure you meet your goals.")
            }
            .padding(.top, 140)
            
            Spacer()
            
            Button {
                viewModel.requestNotificationPermissions()
            } label: {
                Text("Allow Notifications")
                    .font(.headline)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
            
            Button {
                showSkipAlert.toggle()
            } label: {
                Text("Skip for Now")
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 30)
        .background(colorScheme == .dark ? .clear : .gray.opacity(0.15))
        .alert("Aqua will not be able to remind you without notifications", isPresented: $showSkipAlert) {
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }
            Button {
                viewModel.requestNotificationPermissions(skipped: true)
            } label: {
                Text("OK")
            }
        }
    }
}

struct NotificationPermissionRequest_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        NotificationPermissionRequest().environmentObject(viewModel)
    }
}
