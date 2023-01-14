//
//  ViewModel.swift
//  Aqua
//
//  Created by Roland Kajatin on 11/09/2022.
//

import SwiftUI
import WidgetKit
import HealthKit

class ViewModel: ObservableObject {
    @Published private(set) var model: Model {
        didSet {
            setSharedData()
            autosave()
        }
    }
    
    func refresh() {
        readWaterDataFromHealth()
        scheduleNotification()
    }
    
    private let healthStoreManager = HealthStoreManager()
    private var healthWaterDataAvailable = false
    private func readWaterDataFromHealth() {
        healthStoreManager.readWater {
            self.healthWaterDataAvailable = true
            self.model.updateHealthRecords(with: self.healthStoreManager.waterRecords)
        } onError: { error in
            self.healthWaterDataAvailable = false
            print("Something went wrong querying water health data: \(String(describing: error))")
        }
    }
    
    private var notificationManager: NotificationManager?
    private var notificationAuthorized = false
    private func scheduleNotification() {
        if (showTimeToDrinkWarning() && healthWaterDataAvailable) {
            notificationManager!.cancelPreviousNotifications()
            notificationManager!.scheduleTimeToDrinkNotification(timeInterval: 5, dateWhenShows: nil) { error in
                if error != nil {
                    // Handle any errors.
                }
            }
        }
    }
    
    private func setSharedData() {
        let sharedDefault = UserDefaults(suiteName: "group.widget.com.gmail.roland.kajatin")!
        sharedDefault.set(progress, forKey: "waterProgress")
        sharedDefault.set(progressNormalized, forKey: "waterProgressNormalize")
        sharedDefault.set(target, forKey: "waterTarget")
        sharedDefault.set(mostRecentRecord.endDate, forKey: "waterLastDate")
        sharedDefault.set(model.timeToDrink, forKey: "waterTimeToDrink")
        
        // Reload the widget's timeline
        WidgetCenter.shared.reloadTimelines(ofKind: "AquaWidget")
    }
    
    init() {
        if let url = Autosave.url, let autosavedModel = try? Model(url: url) {
            self.model = autosavedModel
        } else {
            self.model = Model()
        }
        
        notificationManager = NotificationManager() {
            self.model.timeToDrink = true
            self.model.timeToDrinkNotification = true
            self.readWaterDataFromHealth()
        }
        
        // Request permission to read/write water health data
        if healthStoreManager.isAuthorization(.notDetermined) {
            model.showHealthPermissionRequest = true
        }
        // Load the water health data from Apple Health
        readWaterDataFromHealth()
        
        // Request notification authorization if it's not already given
        notificationManager!.isAuthorization { settings in
            if (settings.authorizationStatus == .notDetermined) {
                self.model.showNotificationRequest = true
            }
            self.notificationAuthorized = settings.authorizationStatus == .authorized
        }
        // TODO: if we are denied authorization, we should occasionally request it again (maybe)
        // Cancel pending time-to-drink notifications
        notificationManager!.cancelPreviousNotifications()
        
        setSharedData()
        scheduleNotification()
    }
    
    // MARK: Persistance functions
    
    private struct Autosave {
        static let filename = "Autosave.hydration"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try model.json()
//            print("\(thisFunction) json = \(String(data: data, encoding: .utf8) ?? "nil")")
            try data.write(to: url)
//            print("\(thisFunction) success!")
        } catch {
            print("\(thisFunction) = \(error)")
        }
    }
    
    // MARK: Computed vars
    
    var todaysRecords: [HKQuantitySample] {
        model.healthSamples.filter {
            Calendar.autoupdatingCurrent.isDateInToday($0.endDate)
        }
    }
    
    var yesterdaysRecords: [HKQuantitySample] {
        model.healthSamples.filter {
            Calendar.autoupdatingCurrent.isDateInYesterday($0.endDate)
        }
    }
    
    var averageThisWeek: Double {
        let sum = model.healthSamples.filter {
            Calendar.autoupdatingCurrent.isDate($0.endDate, equalTo: Date.now, toGranularity: .weekOfYear)
        }.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum / 7
    }
    
    var averageLastWeek: Double {
        let sum = model.healthSamples.filter {
            Calendar.autoupdatingCurrent.isDate($0.endDate, equalTo: Date(timeIntervalSinceNow: -(7 * 24 * 60 * 60)), toGranularity: .weekOfYear)
        }.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum / 7
    }
    
    var remainder: Double {
        return model.target - progress
    }
    
    var progress: Double {
        let sum = todaysRecords.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum
    }
    
    var progressNormalized: Double {
        return progress / model.target
    }

    var progressYesterday: Double {
        let sum = yesterdaysRecords.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum
    }
    
    var target: Double {
        get { return model.target }
        set { model.target = newValue }
    }
    
    var notificationInterval: Double {
        get { return model.notificationInterval }
        set { model.notificationInterval = newValue.rounded() }
    }
    
    var weeklyRecords: Dictionary<Date, Double> {
        let groupedByDay = Dictionary(grouping: model.healthSamples, by: {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: $0.endDate)
            return Calendar.current.date(from: components)!
        })
        return groupedByDay.mapValues {
            let sum = $0.reduce(0, { sum, record in
                sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
            })
            return sum
        }
    }
    
    var mostRecentRecord: HKQuantitySample {
        if model.healthSamples.isEmpty {
            // Return a dummy old sample with 0 volume
            return HKQuantitySample(type: HKQuantityType(.dietaryWater), quantity: HKQuantity(unit: .literUnit(with: .milli), doubleValue: 0), start: Date(timeIntervalSince1970: 0), end: Date(timeIntervalSince1970: 0))
        }
        
        return model.healthSamples.sorted(by: {
            $0.endDate.compare($1.endDate) == .orderedDescending
        })[0]
    }
    
    var projected: Double {
        let midnight = Calendar(identifier: .gregorian).startOfDay(for: Date(timeIntervalSinceNow: 86400))
        let timeUntilMidnight = midnight.timeIntervalSinceNow
        // TODO: Calculate average intake for real
        let averageIntake: Double = 200
        return progress + (averageIntake * Double(timeUntilMidnight) / 3600)
    }
    
    struct chartItem: Identifiable {
        var id: Date { date }
        let date: Date
        let consumption: Float
    }
    
    func createWeeklyRecordsChartData(_ records: Dictionary<Date, Double>) -> [chartItem] {
        records.map { record in
            return chartItem(date: record.key, consumption: Float(record.value))
        }
    }
    
    func showTimeToDrinkWarning() -> Bool {
        return mostRecentRecord.endDate < Date(timeIntervalSinceNow: -model.notificationInterval)
    }
    
    func showOffTrackWarning() -> Bool {
        return projected < model.target
    }
    
    var showHealthPermissionRequest: Bool {
        get { return model.showHealthPermissionRequest }
        set { model.showHealthPermissionRequest = newValue }
    }
    
    func requestAppleHealthPermissions(skipped: Bool = false) {
        if !skipped {
            healthStoreManager.requestAuthorization { (success, error) in
                if success {
                    self.readWaterDataFromHealth()
                } else {
                    print("Something went wrong while requesting Apple Health permissions: \(String(describing: error))")
                }
            }
        }
        
        model.showHealthPermissionRequest = false
    }
    
    var showNotificationRequest: Bool {
        get { return model.showNotificationRequest }
        set { model.showNotificationRequest = newValue }
    }
    
    func requestNotificationPermissions(skipped: Bool = false) {
        if !skipped {
            notificationManager!.requestAuthorization { (granted, error) in
                if let error = error {
                    // Handle the error here.
                    print(error)
                }
                
                // Enable or disable features based on the authorization.
                
                // Check if we're authorized to send notifications
                self.notificationManager!.isAuthorization { settings in
                    self.notificationAuthorized = settings.authorizationStatus == .authorized
                }
                // TODO: if we are denied authorization, we should occasionally request it again (maybe)
                // Cancel pending time-to-drink notifications
                self.notificationManager!.cancelPreviousNotifications()
            }
        }
        
        model.showNotificationRequest = false
    }
    
    func normalizedProgress(for date: Date) -> CGFloat {
        let sum = model.healthSamples.filter {
            Calendar.autoupdatingCurrent.isDate($0.endDate, equalTo: date, toGranularity: .day)
        }.reduce(0, { sum, record in
            sum + record.quantity.doubleValue(for: .literUnit(with: .milli))
        })
        return sum / model.target
    }
    
    // MARK: Intents
    
    func registerDrink(volume: Double, date: Date) {
        // Add the new water record to Health
        let waterQuantitySample = healthStoreManager.generateQuantitySample(quantity: volume, date: date)
        healthStoreManager.writeWaterSample(waterQuantitySample) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    // Refresh the water records from Health
                    self.model.healthSamples.append(waterQuantitySample)
                }
            } else {
                //TODO: Handle error here
                print("Something went wrong writing health sample: \(String(describing: error))")
            }
        }
        
        model.timeToDrink = false
        
        // Cancel pending time-to-drink notifications
        notificationManager!.cancelPreviousNotifications()
        
        if (progress >= target) {
            return
        }
        
        // Schedule notification for later
        let midnight = Calendar(identifier: .gregorian).startOfDay(for: Date(timeIntervalSinceNow: 86400))
        let timeUntilMidnight = midnight.timeIntervalSinceNow
        let averageIntake: Double = 200
        let timeInterval = (averageIntake * Double(timeUntilMidnight)) / Double(remainder)
        let fireIn: Double = min(timeInterval, model.notificationInterval)
        let dateWhenNotificationShows = Date(timeInterval: fireIn, since: date)
        notificationManager!.scheduleTimeToDrinkNotification(timeInterval: fireIn, dateWhenShows: dateWhenNotificationShows) { error in
            if error != nil {
                // Handle any errors.
            }
        }
    }
    
    func resetSettings() {
        model.restoreDefaults()
    }
    
    func dismissNotification() {
        self.model.timeToDrinkNotification = false
    }
}

extension Date {
    func relativeDayString() -> String {
        if (Calendar.autoupdatingCurrent.isDateInToday(self)) {
            return "Today"
        } else if (Calendar.autoupdatingCurrent.isDateInYesterday(self)) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(for: self)!
        }
    }
    
    func relativeDateString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date.now)
    }
    
    func relativeDateString(to: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: to)
    }
}
