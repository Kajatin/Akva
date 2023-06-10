//
//  Today.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI

struct Today: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showAddDrinkSheet = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                CircularProgressBar(radius: 125)
                    .padding(.top, 40)
                WarningsView()
                StatsView()
                
                VStack {
                    NavigationLink {
                        AllDrinkData()
                    } label: {
                        HStack {
                            Text("Show All Data")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.vertical, 6)
                    }
                    .foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    
                    NavigationLink {
                        TargetSettingView()
                    } label: {
                        HStack {
                            Text("Target")
                            Spacer()
                            Text("\(viewModel.target.formatted()) mL")
                            Image(systemName: "chevron.right")
                        }
                        .padding(.vertical, 6)
                    }
                    .foregroundColor(.primary)
                    .buttonStyle(.bordered)
                }
            }
            .padding(.horizontal)
            .toolbar {
                Button {
                    showAddDrinkSheet.toggle()
                } label: {
                    ZStack {
                        Image(systemName: "plus")
                        if (viewModel.model.timeToDrink) {
                            Image(systemName: "circle.fill")
                                .offset(x: 21, y: -21)
                                .scaleEffect(0.5)
                        }
                    }
                    .foregroundColor(.accentColor)
                    .animation(.spring(), value: viewModel.model.timeToDrink)
                }
            }
        }
        .sheet(isPresented: $showAddDrinkSheet) {
            RegisterWaterIntake()
        }
    }
}

struct Today_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    
    static var previews: some View {
        Today()
            .environmentObject(viewModel)
            .waterDataContainer()
    }
}
