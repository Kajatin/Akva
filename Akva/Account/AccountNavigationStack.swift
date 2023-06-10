//
//  AccountNavigationStack.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI

struct AccountNavigationStack: View {
    var body: some View {
        NavigationStack {
            Account()
                .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountNavigationStack()
}
