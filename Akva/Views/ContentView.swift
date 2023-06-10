//
//  ContentView.swift
//  Aqua
//
//  Created by Roland Kajatin on 10/09/2022.
//

import SwiftUI
import SwiftData
import DiateryWaterData

struct ContentViewN: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Text("\(HealthStoreManagerNew.shared.isHealthKitAuthorized ? "authorized" : "not authorized")")
            Text("\(viewModel.waterData.count)")
            Button {
//                HealthStoreManagerNew.shared.requestAuthorization()
            } label: {
                Text("Request")
            }
//            List(waterData) { data in
//                Text("\(data.waterAmount)")
//            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .badge(NotificationManagerNew.shared.badge)
                .tabItem {
                    Label("Today", systemImage: "house")
                }
            CalendarHistoryView()
                .tabItem {
                    Label("History", systemImage: "calendar")
                }
        }
    }
}

struct TodayView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State private var showAddDrinkSheet = true

    var body: some View {
        NavigationView {
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
                .navigationBarTitle(Text("Today"))
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
                RegisterHydration()
            }
        }
    }
}

struct RegisterHydration: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode

    private let volumeAmounts: [Double] = [100, 150, 200, 250, 300, 350]
    @State private var selectedVolume: Double = 200
    @State private var date = Date()

    var body: some View {
        NavigationView {
            Form {
                Picker("Volume", selection: $selectedVolume) {
                    ForEach(volumeAmounts, id: \.self) { volume in
                        Text("\(volume.formatted())")
                    }
                }
                .pickerStyle(.inline)

                Section("Date") {
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    DatePicker(
                        "Time",
                        selection: $date,
                        displayedComponents: [.hourAndMinute]
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.registerDrink(volume: selectedVolume, date: date)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Add")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static let viewModel = ViewModel()

    static var previews: some View {
        ContentView()
            .environmentObject(viewModel)
            .waterDataContainer()
    }
}
