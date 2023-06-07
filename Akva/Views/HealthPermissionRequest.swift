//
//  HealthPermissionRequest.swift
//  Aqua
//
//  Created by Roland Kajatin on 01/10/2022.
//

import SwiftUI

struct HealthPermissionRequest: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showSkipAlert = false
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 25) {
                Image("Icon - Apple Health")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64)
                Text("Automatically sync your water intake records with Apple Health")
                    .font(.title)
                    .bold()
                Text("Using Aqua with the Apple Health app on iPhone enables you to consolidate your diatery water intake information in one place. Aqua shows you intake trends and notifications to help you reach your goals.")
            }
            .padding(.top, 140)
            
            Spacer()
            
            Button {
                viewModel.requestAppleHealthPermissions()
            } label: {
                Text("Sync Health Data")
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
        .alert("Aqua will not function properly without Apple Health", isPresented: $showSkipAlert) {
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }
            Button {
                viewModel.requestAppleHealthPermissions(skipped: true)
            } label: {
                Text("OK")
            }
        }
    }
}

struct HealthPermissionRequest_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        HealthPermissionRequest().environmentObject(viewModel)
    }
}
