//
//  Today.swift
//  Akva
//
//  Created by Roland Kajatin on 10/06/2023.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct TodayN: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showAddDrinkSheet = false
    
    @Query private var waterData: [WaterData]
    
    var body: some View {
        if let data = waterData.first {
            VStack {
                Text("Some data: \(data.samples.count)")
                Text("Progress: \(data.progress)")
                Button {
                    data.addConsumption(quantity: 200, date: .now)
                } label: {
                    Text("Add")
                }.padding(.bottom, 40)
            }
        } else {
            ContentUnavailableView("Content unavailable", systemImage: "xmark.circle")
        }
    }
}

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
                                Text("\(data.target) mL")
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
                                    .offset(x: 21, y: -21)
                                    .scaleEffect(0.5)
                            }
                        }
                        .foregroundColor(.accentColor)
                        .animation(.spring(), value: data.timeToDrink)
                    }
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
