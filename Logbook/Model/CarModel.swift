//
//  CarModel.swift
//  Logbook
//
//  Created by sam on 2/27/22.
//

import Foundation

struct Car: Identifiable, Codable, Comparable {
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
    var maint: [MaintSched] = []
    var logs: [Log] = []
    
    static func new() -> Car {
        var newCar = Car()
        self.setupMaintRec(car: &newCar)
        return newCar
    }
    
    private static func setupMaintRec (car: inout Car) {
        for t in LogType.allCases {
            let m = MaintSched(maintType: t, maintEnabled: LogType.maintEnabledDefault(t)(), maintMonths: LogType.maintDateDefault(t)(), maintMiles: LogType.maintMilesDefault(t)())
            car.maint.append(m)
        }
    }
    
    static func add(cars: inout [Car], newCar: Car) {
        cars.append(newCar)
        cars = self.sortCars(cars: cars)
    }
    
    static func remove(cars: inout [Car], carIndex: IndexSet) {
        cars.remove(atOffsets: carIndex)
    }

    static func loadSampleData() -> [Car]{
        var  cars = Car.sampleCars
        cars = self.sortCars(cars: cars)
        for i in 0..<cars.count {
            self.setupMaintRec(car: &cars[i])
        }
        
        return cars
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
        Car(year: year, make: make, model: model, unique: unique, license: license, vin: vin, maint: maint, logs: logs)
    }
    
    mutating func update(from data: Car) {
        year = data.year
        make = data.make
        model = data.model
        unique = data.unique
        license = data.license
        vin = data.vin
        maint = data.maint
        logs = data.logs
        for t in LogType.allCases {
            let m = MaintSched(maintType: t, maintEnabled: LogType.maintEnabledDefault(t)(), maintMonths: LogType.maintDateDefault(t)(), maintMiles: LogType.maintMilesDefault(t)())
            maint.append(m)
        }
    }
}

extension Car {
    // MARK: return sample data
    static let sampleCars: [Car] = [
        Car(year: "2012", make: "Lexus", model: "IS250", unique: "2012 Lexus",
            logs: [
                Log(date: convertDate(date: "2022-10-30"), type: LogType.odometer, odometer: 107545, details: "", vendor: "", cost: 0),
                Log(date: convertDate(date: "2022-03-31"), type: LogType.brakes, odometer: 105185, details: "", vendor: "Roo", cost: 600.00),
                Log(date: convertDate(date: "2022-03-30"), type: LogType.oil, odometer: 105150, details: "", vendor: "Evans", cost: 78.00),
                Log(date: convertDate(date: "2021-07-21"), type: LogType.tires, odometer: 97965, details: "", vendor: "Costco", cost: 671.27),
                Log(date: convertDate(date: "2021-08-10"), type: LogType.smog, odometer: 98207, details: "", vendor: "Akon Auto Center", cost: 48.20),
                Log(date: convertDate(date: "2021-08-10"), type: LogType.alignment, odometer: 98196, details: "", vendor: "EDZ Tires", cost: 59.00),
                Log(date: convertDate(date: "2020-12-27"), type: LogType.oil, odometer: 92633, details: "", vendor: "Valvoline Scripps Ranch", cost: 72.82),
                Log(date: convertDate(date: "2019-08-13"), type: LogType.smog, odometer: 82676, details: "", vendor: "Antonio", cost: 40.00),
                Log(date: convertDate(date: "2018-11-18"), type: LogType.tires, odometer: 75627, details: "", vendor: "Costco", cost: 900.00),
                Log(date: convertDate(date: "2018-07-17"), type: LogType.battery, odometer: 72940, details: "", vendor: "Costco", cost: 105.59),
                Log(date: convertDate(date: "2018-07-18"), type: LogType.other, odometer: 72947, details: "Service", vendor: "Roo Automotive", cost: 135.00),
                Log(date: convertDate(date: "2016-11-18"), type: LogType.oil, odometer: 55089, details: "", vendor: "RB Automotive", cost: 99.89),
                Log(date: convertDate(date: "2016-07-01"), type: LogType.oil, odometer: 50155, details: "", vendor: "RB Automotive", cost: 99.89),
                Log(date: convertDate(date: "2018-03-17"), type: LogType.oil, odometer: 71258, details: "", vendor: "Valvoline Scripps Ranch", cost: 75.01),
                Log(date: convertDate(date: "2018-12-17"), type: LogType.oil, odometer: 76547, details: "", vendor: "Valvoline Scripps Ranch", cost: 82.82),
                Log(date: convertDate(date: "2021-09-19"), type: LogType.oil, odometer: 99420, details: "", vendor: "Valvoline Scripps Ranch", cost: 55.48),
            ]),
        Car(year: "2018", make: "Nissan", model: "Pathfinder", unique: "2018 Nissan",
            logs: [
                Log(date: convertDate(date: "2022-08-12"), type: LogType.oil, odometer: 88553, details: "", vendor: "Valvoline", cost: 59.20),
                Log(date: convertDate(date: "2022-04-08"), type: LogType.brakes, odometer: 82963, details: "Both front/back", vendor: "Roo Automotive", cost: 690),
                Log(date: convertDate(date: "2020-01-24"), type: LogType.brakes, odometer: 40086, details: "Both front/back", vendor: "Roo Automotive", cost: 593),
                Log(date: convertDate(date: "2022-04-08"), type: LogType.oil, odometer: 82963, details: "", vendor: "Roo Automotive", cost: 70.00),
                Log(date: convertDate(date: "2021-12-18"), type: LogType.tires, odometer: 77327, details: "(2) Michelin Defender 235/65R18, 70K warranty", vendor: "Discount Tire", cost: 406.23),
                Log(date: convertDate(date: "2021-06-28"), type: LogType.oil, odometer: 69612, details: "", vendor: "Valvoline", cost: 41.71),
                Log(date: convertDate(date: "2021-02-22"), type: LogType.oil, odometer: 61568, details: "", vendor: "Valvoline", cost: 47.09),
                Log(date: convertDate(date: "2020-10-30"), type: LogType.battery, odometer: 55000, details: "", vendor: "Costco", cost: 87.27),
                Log(date: convertDate(date: "2020-07-10"), type: LogType.oil, odometer: 47524, details: "", vendor: "Valvoline", cost: 70.53),
                Log(date: convertDate(date: "2019-02-09"), type: LogType.oil, odometer: 22071, details: "", vendor: "Valvoline", cost: 65.91),
                Log(date: convertDate(date: "2019-05-27"), type: LogType.oil, odometer: 27811, details: "", vendor: "Valvoline", cost: 65.90),
                Log(date: convertDate(date: "2019-12-31"), type: LogType.oil, odometer: 38753, details: "", vendor: "Valvoline", cost: 67.03),
                Log(date: convertDate(date: "2018-10-05"), type: LogType.oil, odometer: 14315, details: "", vendor: "Mossy Nissan", cost: 65.29),
                Log(date: convertDate(date: "2018-06-25"), type: LogType.oil, odometer: 8500, details: "", vendor: "Antonio's", cost: 92.26),
                Log(date: convertDate(date: "2019-02-13"), type: LogType.tires, odometer: 22233, details: "(2) Michelin Defender 235/65R18", vendor: "Discount Tire", cost: 464.66),
                Log(date: convertDate(date: "2019-07-06"), type: LogType.tires, odometer: 30000, details: "(2) Michelin Defender 235/65R18", vendor: "Discount Tire", cost: 457.42),
                Log(date: convertDate(date: "2019-12-24"), type: LogType.rotate, odometer: 38239, details: "", vendor: "Discount Tire", cost: 0),
                Log(date: convertDate(date: "2021-12-16"), type: LogType.odometer, odometer: 77220, details: "ABS recall", vendor: "Mossy Nissan", cost: 0),
            ]),
        Car(year: "2006", make: "Porsche", model: "Cayman", unique: "2006 Porsche",
            logs: [
                Log(date: convertDate(date: "2022-06-11"), type: LogType.smog, odometer: 81066, details: "", vendor: "Antonio's", cost: 59.99),
                Log(date: convertDate(date: "2021-08-05"), type: LogType.oil, odometer: 78497, details: "", vendor: "Performance", cost: 159.24),
                Log(date: convertDate(date: "2019-04-04"), type: LogType.other, odometer: 72944, details: "Balance new wheels", vendor: "Discount Tire", cost: 76),
                Log(date: convertDate(date: "2018-12-19"), type: LogType.oil, odometer: 72292, details: "", vendor: "Performance", cost: 129.74),
                Log(date: convertDate(date: "2018-01-12"), type: LogType.oil, odometer: 67314, details: "", vendor: "Performance", cost: 131.89),
                Log(date: convertDate(date: "2017-04-20"), type: LogType.other, odometer: 63075, details: "Window Regulator", vendor: "Performance", cost: 482.31),
                Log(date: convertDate(date: "2017-02-21"), type: LogType.other, odometer: 62553, details: "Purchased from Rob Chong", vendor: "Performance", cost: 22700),
            ]),
    ]
}
