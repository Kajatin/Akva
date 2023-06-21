//
//  About.swift
//  Akva
//
//  Created by Roland Kajatin on 17/06/2023.
//

import SwiftUI

struct About: View {
    var versionNumber: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown Version"
    }
    
    var buildNumber: String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Unknown Build"
    }
    
    var body: some View {
        Form {
            Section(header: Text("App Information")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(versionNumber)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Build")
                    Spacer()
                    Text(buildNumber)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("About")
    }
}

#Preview {
    About()
}
