//
//  CarModel.swift
//  Logbook
//
//  Created by sam on 2/27/22.
//

import Foundation
import os.log

struct Car99: Identifiable, Codable, Comparable {
    static func < (lhs: Car, rhs: Car) -> Bool {
        return lhs.make > rhs.make
    }
    
    var id: UUID = UUID()
    var year: String = ""
    var make: String = ""
    var model: String = ""
    var unique: String = ""
    var license: String = ""
    var vin: String = ""
    var purchaseDate: Date = Date()
    var notes: String = ""
    var services: [Service] = []
    var logs: [Log] = []
    var reminders: [Reminder] = []
    var overdueRemindersCount: Int = 0
    var upcomingRemindersCount: Int = 0
    
    // MARK: - Model Management
    static func new() -> Car {
        var newCar = Car()
        self.setupServicesRec(car: &newCar)
        return newCar
    }
    
    static func setupServicesRec (car: inout Car) {
        for t in ServiceType.allCases {
            let s = Service(serviceType: t, maintEnabled: ServiceType.maintEnabledDefault(t)(), maintMonths: ServiceType.maintDateDefault(t)(), maintMiles: ServiceType.maintMilesDefault(t)())
            car.services.append(s)
        }
    }
    
    static func add(cars: inout [Car], newCar: Car) {
        cars.append(newCar)
        cars = self.sortCars(cars: cars)
    }
    
    static func remove(cars: inout [Car], carIndex: IndexSet) {
        cars.remove(atOffsets: carIndex)
    }
    
    static func clearReminders(car: inout Car) {
        car.overdueRemindersCount = 0
        car.upcomingRemindersCount = 0
        car.reminders = []
    }
    
    static func sortCars(cars: [Car]) -> [Car] {
        var cars = cars.sorted { $0.make < $1.make }
        
        for i in 0..<cars.count {
            cars[i].logs = Log.sortLogs(logs: cars[i].logs)
        }
        
        return cars
    }
}

extension Car {
    var data: Car {
        Car(year: year, make: make, model: model, unique: unique, license: license, vin: vin, services: services, logs: logs, reminders: reminders, overdueRemindersCount: overdueRemindersCount, upcomingRemindersCount: upcomingRemindersCount)
    }
    
    mutating func update(from data: Car) {
        year = data.year
        make = data.make
        model = data.model
        unique = data.unique
        license = data.license
        vin = data.vin
        services = data.services
        logs = data.logs
        reminders = data.reminders
        overdueRemindersCount = data.overdueRemindersCount
        upcomingRemindersCount = data.upcomingRemindersCount
        for t in ServiceType.allCases {
            let s = Service(serviceType: t, maintEnabled: ServiceType.maintEnabledDefault(t)(), maintMonths: ServiceType.maintDateDefault(t)(), maintMiles: ServiceType.maintMilesDefault(t)())
            services.append(s)
        }
    }
}
