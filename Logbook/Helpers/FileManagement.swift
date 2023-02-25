//
//  FileManagement.swift
//  Logbook
//
//  Created by bugs on 2/21/23.
//

import Foundation
import os.log

// MARK: - Export/Import
/*
private func textFileURL(fn: String) throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                in: .userDomainMask,
                                appropriateFor: nil,
                                create: false)
    .appendingPathComponent(fn)
}
 
func exportTextData(cars: [Car99]) {
    var textData: String
    os_log("Text file directory: %{public}@", log: appLog, type: .info, documentsDirectory as CVarArg)
    
    do {
        // cars
        textData = "car_id  year    make    model   unique  license vin purchaseDate    notes\n"
        for (i, c) in cars.enumerated() {
            textData = textData.appending("\(i)\t\(c.year)\t\(c.make)\t\(c.model)\t\(c.unique)\t\(c.license)\t\(c.vin)\t\(c.purchaseDate)\t\(c.notes)\n")
        }
        try textData.write(to: textFileURL(fn: CARS_TEXT_FILE), atomically: true, encoding: .utf8)
        
        // services
        textData = "car_id  service maintEnabled    maintMonths maintMiles\n"
        for (i, c) in cars.enumerated() {
            for s in c.services {
                textData = textData.appending("\(i)\t\(s.serviceType.rawValue)\t\(s.maintEnabled)\t\(s.maintMonths)\t\(s.maintMiles)\n")
            }
        }
        try textData.write(to: textFileURL(fn: SERVICES_TEXT_FILE), atomically: true, encoding: .utf8)

        // logs
        textData = "car_id  date    service odometer    details vendor  cost\n"
        for (i, c) in cars.enumerated() {
            for log in c.logs {
                textData = textData.appending("\(i)\t\(log.date)\t\(log.type.rawValue)\t\(log.odometer)\t\(log.details)\t\(log.vendor)\t\(log.cost)\n")
            }
        }
        try textData.write(to: textFileURL(fn: LOGS_TEXT_FILE), atomically: true, encoding: .utf8)

        // reminders
        textData = "car_id  service dateStatus  milesStatus dateDue\n"
        for (i, c) in cars.enumerated() {
            for r in c.reminders {
                textData = textData.appending("\(i)\t\(r.serviceType)\t\(r.dateStatus)\t\(r.milesStatus)\t\(r.dateDue)\t\(r.daysUntilDue)\t\(r.milesDue)\t\(r.milesUntilDue)\n")
            }
        }
        try textData.write(to: textFileURL(fn: REMINDERS_TEXT_FILE), atomically: true, encoding: .utf8)

    } catch {
        os_log("Error saving CSV file.", log: appLog, type: .error)
        _ = ErrorWrapper(error: Error.self as! Error, guidance: "Error exporting text file, try again later.")
    }
}
*/

/*
func loadTextData() {
     importTextData()
    /*
     for i in 0..<cars.count {
         print(i)
         //Reminder99.updateReminders(car: &cars[i], carIndex: i)
     }
     */
}

func importTextData() {
    var importCars : [String]
    var rows: [String]
    
    // cars file
    rows = getFileRows(fn: "cars", type: "csv", header: true)
    for row in rows {
        let c = row.components(separatedBy: "\t")
        if c.count == 9 {
            newCar = Car(context: )
            let newCar = Car99(id: UUID(), year: c[1], make: c[2], model: c[3], unique: c[4], license: c[5], vin: c[6], purchaseDate: convertDate(date: c[7]), notes: c[8])
            importCars.append(newCar)
        }
    }
    
    // services file
    rows = getFileRows(fn: "services", type: "csv", header: true)
    for row in rows {
        let c = row.components(separatedBy: "\t")
        if c.count == 5 {
            let newService = Service99(id: UUID(), serviceType: ServiceType(rawValue: c[1]) ?? .other, maintEnabled: Bool(c[2]) ?? false, maintMonths: Int(c[3]) ?? 0, maintMiles: Int(c[4]) ?? 0)
            
            importCars[Int(c[0])!].services.append(newService)
        }
    }
    
    // logs file
    rows = getFileRows(fn: "logs", type: "csv", header: true)
    for row in rows {
        let c = row.components(separatedBy: "\t")
        if c.count == 7 {
            let newLog = Log99(id: UUID(), date: convertDate(date: c[1]), type: ServiceType(rawValue: c[2]) ?? .other, odometer: Int(c[3]) ?? 0, details: c[4], vendor: c[5], cost: Float(c[6])!)
            
            importCars[Int(c[0])!].logs.append(newLog)
        }
    }
    
    return []
}

// code borrowed from here https://stackoverflow.com/questions/32313938/parsing-csv-file-in-swift
private func getFileRows(fn: String, type: String, header: Bool) -> [String] {
    var data = ""

    //locate the services file
    guard let filepath = Bundle.main.path(forResource: fn, ofType: type) else {
        os_log("Error reading %@.%@ file.", log: appLog, type: .error, fn, type)
        return []
    }

    //convert that file into one long string
    do {
        data = try String(contentsOfFile: filepath)
    } catch {
        os_log("Error reading %@.%@ file.", log: appLog, type: .error, fn, type)
        return []
    }

    //now split that string into an array of "rows" of data.  Each row is a string.
    var rows = data.components(separatedBy: "\n")

    if (header) {
        rows.removeFirst()
    }

    return rows
}
*/

// MARK: - Data File Management
// Scrumdinger methods below
/*
private  func dataFileURL() throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                in: .userDomainMask,
                                appropriateFor: nil,
                                create: false)
    .appendingPathComponent(DATA_FILE)
}

func loadData() async throws -> [Car99] {
    try await withCheckedThrowingContinuation { continuation in
        loadData { result in
            switch result {
            case .failure(let error):
                continuation.resume(throwing: error)
            case .success(let cars):
                continuation.resume(returning: cars)
            }
        }
    }
}

func loadData(completion: @escaping (Result<[Car99], Error>)->Void) {
    DispatchQueue.global(qos: .background).async {
        do {
            let fileURL = try dataFileURL()
            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
                return
            }
            var cars = try JSONDecoder().decode([Car99].self, from: file.availableData)
            DispatchQueue.main.async {
                cars = cars.sorted { $0.make < $1.make }
                os_log("Loaded data file: %d cars", log: appLog, type: .info, cars.count)
                for var c in cars {
                    c.logs = c.logs.sorted {  $0.date > $1.date }
                    os_log("%d logs for %{public}@", log: appLog, type: .info, c.logs.count, c.model)
                }
                
                completion(.success(cars))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}

@discardableResult
func saveData(cars: [Car99]) async throws -> Int {
    try await withCheckedThrowingContinuation { continuation in
        saveData(cars: cars) { result in
            switch result {
            case .failure(let error):
                continuation.resume(throwing: error)
            case .success(let carsSaved):
                continuation.resume(returning: carsSaved)
            }
        }
    }
}

func saveData(cars: [Car99], completion: @escaping (Result<Int, Error>)->Void) {
    DispatchQueue.global(qos: .background).async {
        do {
            let data = try JSONEncoder().encode(cars)
            let outfile = try dataFileURL()
            os_log("saveData: Data file directory: %{public}@", log: appLog, type: .info, documentsDirectory as CVarArg)

            try data.write(to: outfile)
            DispatchQueue.main.async {
                completion(.success(cars.count))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Sample Data
func loadSampleData() -> [Car99] {
    var  cars = sampleCars
    cars = Car99.sortCars(cars: cars)
    for i in 0..<cars.count {
        Car99.setupServicesRec(car: &cars[i])
        Reminder99.updateReminders(car: &cars[i], carIndex: i)
    }
    
    return cars
}

let sampleCars: [Car99] = [
    Car(year: "2012", make: "Lexus", model: "IS250", unique: "2012 Lexus", license: "", vin: "JTHBF5C28B5154168", purchaseDate: convertDate(date: "2016-05-01"),
        logs: [
            Log(date: convertDate(date: "2023-01-13"), type: ServiceType.odometer, odometer: 110631, details: "+ 2 Q of oil", vendor: "", cost: 0),
            Log(date: convertDate(date: "2022-10-30"), type: ServiceType.odometer, odometer: 107545, details: "+ 1 Q of oil", vendor: "", cost: 0),
            Log(date: convertDate(date: "2022-03-31"), type: ServiceType.brakes, odometer: 105185, details: "", vendor: "Roo", cost: 600.00),
            Log(date: convertDate(date: "2022-03-30"), type: ServiceType.oil, odometer: 105150, details: "", vendor: "Evans", cost: 78.00),
            Log(date: convertDate(date: "2021-07-21"), type: ServiceType.tires, odometer: 97965, details: "", vendor: "Costco", cost: 671.27),
            Log(date: convertDate(date: "2021-09-19"), type: ServiceType.oil, odometer: 99420, details: "", vendor: "Valvoline Scripps Ranch", cost: 55.48),
            Log(date: convertDate(date: "2021-08-10"), type: ServiceType.smog, odometer: 98207, details: "", vendor: "Akon Auto Center", cost: 48.20),
            Log(date: convertDate(date: "2021-08-10"), type: ServiceType.alignment, odometer: 98196, details: "", vendor: "EDZ Tires", cost: 59.00),
            Log(date: convertDate(date: "2020-12-27"), type: ServiceType.oil, odometer: 92633, details: "", vendor: "Valvoline Scripps Ranch", cost: 72.82),
            Log(date: convertDate(date: "2019-08-13"), type: ServiceType.smog, odometer: 82676, details: "", vendor: "Antonio", cost: 40.00),
            Log(date: convertDate(date: "2018-11-18"), type: ServiceType.tires, odometer: 75627, details: "", vendor: "Costco", cost: 900.00),
            Log(date: convertDate(date: "2018-07-17"), type: ServiceType.battery, odometer: 72940, details: "", vendor: "Costco", cost: 105.59),
            Log(date: convertDate(date: "2018-07-18"), type: ServiceType.other, odometer: 72947, details: "Service", vendor: "Roo Automotive", cost: 135.00),
            Log(date: convertDate(date: "2016-11-18"), type: ServiceType.oil, odometer: 55089, details: "", vendor: "RB Automotive", cost: 99.89),
            Log(date: convertDate(date: "2016-07-01"), type: ServiceType.oil, odometer: 50155, details: "", vendor: "RB Automotive", cost: 99.89),
            Log(date: convertDate(date: "2018-03-17"), type: ServiceType.oil, odometer: 71258, details: "", vendor: "Valvoline Scripps Ranch", cost: 75.01),
            Log(date: convertDate(date: "2018-12-17"), type: ServiceType.oil, odometer: 76547, details: "", vendor: "Valvoline Scripps Ranch", cost: 82.82),
        ]),
    Car(year: "2018", make: "Nissan", model: "Pathfinder", unique: "2018 Nissan", license: "8CJE574", vin: "5N1DR2MN7JC610823", purchaseDate: convertDate(date: "2018-01-30"),
        logs: [
            Log(date: convertDate(date: "2023-02-19"), type: ServiceType.other, odometer: 96733, details: "Wiper blades", vendor: "", cost: 20.00),
            Log(date: convertDate(date: "2023-01-13"), type: ServiceType.other, odometer: 95112, details: "Replace PCV valve, mass airflow sensor, and air filter", vendor: "Roo", cost: 546.44),
            Log(date: convertDate(date: "2022-12-20"), type: ServiceType.oil, odometer: 94473, details: "", vendor: "Valvoline", cost: 53.58),
            Log(date: convertDate(date: "2022-08-12"), type: ServiceType.oil, odometer: 88553, details: "", vendor: "Valvoline", cost: 59.20),
            Log(date: convertDate(date: "2022-04-08"), type: ServiceType.brakes, odometer: 82963, details: "Both front/back", vendor: "Roo Automotive", cost: 690),
            Log(date: convertDate(date: "2022-04-08"), type: ServiceType.oil, odometer: 82963, details: "", vendor: "Roo Automotive", cost: 70.00),
            Log(date: convertDate(date: "2021-12-18"), type: ServiceType.tires, odometer: 77327, details: "(2) Michelin Defender 235/65R18, 70K warranty", vendor: "Discount Tire", cost: 406.23),
            Log(date: convertDate(date: "2021-12-16"), type: ServiceType.odometer, odometer: 77220, details: "ABS recall", vendor: "Mossy Nissan", cost: 0),
            Log(date: convertDate(date: "2021-06-28"), type: ServiceType.oil, odometer: 69612, details: "", vendor: "Valvoline", cost: 41.71),
            Log(date: convertDate(date: "2021-02-22"), type: ServiceType.oil, odometer: 61568, details: "", vendor: "Valvoline", cost: 47.09),
            Log(date: convertDate(date: "2020-10-30"), type: ServiceType.battery, odometer: 55000, details: "", vendor: "Costco", cost: 87.27),
            Log(date: convertDate(date: "2020-07-10"), type: ServiceType.oil, odometer: 47524, details: "", vendor: "Valvoline", cost: 70.53),
            Log(date: convertDate(date: "2020-01-24"), type: ServiceType.brakes, odometer: 40086, details: "Both front/back", vendor: "Roo Automotive", cost: 593),
            Log(date: convertDate(date: "2019-12-31"), type: ServiceType.oil, odometer: 38753, details: "", vendor: "Valvoline", cost: 67.03),
            Log(date: convertDate(date: "2019-12-24"), type: ServiceType.rotate, odometer: 38239, details: "", vendor: "Discount Tire", cost: 0),
            Log(date: convertDate(date: "2019-07-06"), type: ServiceType.tires, odometer: 30000, details: "(2) Michelin Defender 235/65R18", vendor: "Discount Tire", cost: 457.42),
            Log(date: convertDate(date: "2019-05-27"), type: ServiceType.oil, odometer: 27811, details: "", vendor: "Valvoline", cost: 65.90),
            Log(date: convertDate(date: "2019-02-13"), type: ServiceType.tires, odometer: 22233, details: "(2) Michelin Defender 235/65R18", vendor: "Discount Tire", cost: 464.66),
            Log(date: convertDate(date: "2019-02-09"), type: ServiceType.oil, odometer: 22071, details: "", vendor: "Valvoline", cost: 65.91),
            Log(date: convertDate(date: "2018-10-05"), type: ServiceType.oil, odometer: 14315, details: "", vendor: "Mossy Nissan", cost: 65.29),
            Log(date: convertDate(date: "2018-06-25"), type: ServiceType.oil, odometer: 8500, details: "", vendor: "Antonio's", cost: 92.26),
        ]),
    Car(year: "2006", make: "Porsche", model: "Cayman", unique: "2006 Porsche", license: "", vin: "WPOAB298116U785424", purchaseDate: convertDate(date: "2017-02-21"),
        logs: [
            Log(date: convertDate(date: "2023-01-20"), type: ServiceType.odometer, odometer: 82450, details: "", vendor: "Break pads can go +1000 miles", cost: 0),
            Log(date: convertDate(date: "2023-01-13"), type: ServiceType.odometer, odometer: 82411, details: "", vendor: "Break pads warning light", cost: 0),
            Log(date: convertDate(date: "2022-06-11"), type: ServiceType.smog, odometer: 81066, details: "", vendor: "Antonio's", cost: 59.99),
            Log(date: convertDate(date: "2021-08-05"), type: ServiceType.oil, odometer: 78497, details: "", vendor: "Performance", cost: 159.24),
            Log(date: convertDate(date: "2020-12-31"), type: ServiceType.battery, odometer: 76000, details: "Mileage estimated", vendor: "Costco", cost: 160.54),
            Log(date: convertDate(date: "2019-04-04"), type: ServiceType.other, odometer: 72944, details: "Balance new wheels", vendor: "Discount Tire", cost: 76),
            Log(date: convertDate(date: "2019-04-04"), type: ServiceType.other, odometer: 72944, details: "New wheels w/tires 8/32", vendor: "Hank (OfferUp) - DOT 21st/28th weeks of 2015", cost: 1200),
            Log(date: convertDate(date: "2018-12-19"), type: ServiceType.oil, odometer: 72292, details: "", vendor: "Performance", cost: 129.74),
            Log(date: convertDate(date: "2018-01-12"), type: ServiceType.oil, odometer: 67314, details: "", vendor: "Performance", cost: 131.89),
            Log(date: convertDate(date: "2017-09-01"), type: ServiceType.tires, odometer: 65000, details: "Estimated age/date for tires inclued with the wheels purchased on 4/4/19", vendor: "Michelin", cost: 0),
            Log(date: convertDate(date: "2017-04-20"), type: ServiceType.other, odometer: 63075, details: "Window Regulator", vendor: "Performance", cost: 482.31),
            Log(date: convertDate(date: "2017-02-21"), type: ServiceType.other, odometer: 62553, details: "Purchased from Rob Chong", vendor: "Performance", cost: 22700),
            Log(date: convertDate(date: "2015-04-09"), type: ServiceType.other, odometer: 57791, details: "New lug bot", vendor: "Wheel Enhancement", cost: 91.30),
            Log(date: convertDate(date: "2014-11-22"), type: ServiceType.oil, odometer: 55996, details: "", vendor: "Pacific Porsche", cost: 209.75),
            Log(date: convertDate(date: "2014-03-06"), type: ServiceType.battery, odometer: 52519, details: "", vendor: "AAA", cost: 185.61),
            Log(date: convertDate(date: "2013-09-07"), type: ServiceType.rotate, odometer: 50048, details: "", vendor: "American Tire", cost: 60),
            Log(date: convertDate(date: "2013-09-04"), type: ServiceType.other, odometer: 50024, details: "Replacde Air Mass Sensor", vendor: "Auto Werkstat", cost: 817.19),
            Log(date: convertDate(date: "2013-08-28"), type: ServiceType.oil, odometer: 49962, details: "", vendor: "Auto Werkstat", cost: 0),
            Log(date: convertDate(date: "2013-08-28"), type: ServiceType.other, odometer: 49962, details: "Maintenance service", vendor: "Auto Werkstat", cost: 165),
            Log(date: convertDate(date: "2012-02-06"), type: ServiceType.oil, odometer: 44937, details: "", vendor: "Auto Werkstat", cost: 0),
            Log(date: convertDate(date: "2012-02-06"), type: ServiceType.other, odometer: 44937, details: "Clutch Kit + Service", vendor: "Auto Werkstat", cost: 3530),
            Log(date: convertDate(date: "2011-05-11"), type: ServiceType.oil, odometer: 39425, details: "", vendor: "Pacific Porsche", cost: 148.99),
            Log(date: convertDate(date: "2011-05-11"), type: ServiceType.brakes, odometer: 39425, details: "Replaced front and rear barke pads", vendor: "Pacific Porsche", cost: 1360.09),
            Log(date: convertDate(date: "2010-11-06"), type: ServiceType.oil, odometer: 35119, details: "", vendor: "Pacific Porsche", cost: 176.21),
            Log(date: convertDate(date: "2010-06-18"), type: ServiceType.other, odometer: 32182, details: "Pre purchase inspection", vendor: "Pacific Porsche", cost: 310),
            Log(date: convertDate(date: "2011-05-03"), type: ServiceType.odometer, odometer: 31814, details: "Auction", vendor: "", cost: 0),
            Log(date: convertDate(date: "2008-09-22"), type: ServiceType.odometer, odometer: 18378, details: "DMV", vendor: "", cost: 0),
            Log(date: convertDate(date: "2008-05-21"), type: ServiceType.odometer, odometer: 18357, details: "Auction as dealer car", vendor: "", cost: 0),
            Log(date: convertDate(date: "2007-04-27"), type: ServiceType.odometer, odometer: 7946, details: "", vendor: "DMV", cost: 0),
            Log(date: convertDate(date: "2006-08-23"), type: ServiceType.odometer, odometer: 21, details: "", vendor: "DMV", cost: 0),
        ]),
]
*/
