//
//  Today.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct Today: View {
    @Query private var waterData: [WaterData]
    @State private var showAddDrinkSheet = false
    
    var body: some View {
        if let data = waterData.first {
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
                                Text("\(data.target.formatted()) mL")
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
                            if (data.timeToDrink) {
                                Image(systemName: "circle.fill")
                                    .offset(x: 25, y: -25)
                                    .scaleEffect(0.45)
                            }
                        }
                        .foregroundColor(.accentColor)
                        .animation(.spring(), value: data.timeToDrink)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .sheet(isPresented: $showAddDrinkSheet) {
                RegisterWaterIntake()
            }
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}
    
#Preview {
    Today()
        .waterDataContainer(inMemory: true)
}
