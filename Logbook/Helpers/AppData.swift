//
//  AppData.swift
//  Logbook
//
//  Created by bugs on 2/26/23.
//

import CoreData
import os.log

func importData() {
    var cRows: [String]
    var sRows: [String]
    var lRows: [String]
    var newCar : Car
    var newService : Service
    var newLog : Log

    // read rows from the data files
    cRows = getFileRows(fn: "cars", type: "csv", header: true)
    sRows = getFileRows(fn: "services", type: "csv", header: true)
    lRows = getFileRows(fn: "logs", type: "csv", header: true)
    
    // column 0 in each row is the car index and it is used below to add services/logs to its car

    // cars file
    for cRow in cRows {
        let c = cRow.components(separatedBy: "\t")
        if c.count == 9 {
            newCar = Car(context: PersistenceController.shared.viewContext)
            newCar.id = UUID()
            newCar.year = c[1]
            newCar.make = c[2]
            newCar.model = c[3]
            newCar.unique = c[4]
            newCar.license = c[5]
            newCar.vin = c[6]
            newCar.purchaseDate = convertDate(date: c[7])
            newCar.notes = c[8]
            
            // services file
            for sRow in sRows {
                let s = sRow.components(separatedBy: "\t")
                if (s.count == 5 && s[0] == c[0]) {
                    newService = Service(context: PersistenceController.shared.viewContext)
                    newService.id = UUID()
                    newService.serviceType = s[1]
                    newService.maintEnabled = Bool(s[2]) ?? false
                    newService.maintMonths = Int32(s[3]) ?? 0
                    newService.maintMiles = Int32(s[4]) ?? 0
                    newCar.addToServices(newService)
                }
            }
            
            // logs file
            for lRow in lRows {
                let l = lRow.components(separatedBy: "\t")
                if (l.count == 7 && l[0] == c[0]) {
                    newLog = Log(context: PersistenceController.shared.viewContext)
                    newLog.id = UUID()
                    newLog.date = convertDate(date: l[1])
                    newLog.serviceType = l[2]
                    newLog.odometer = Int32(l[3]) ?? 0
                    newLog.details = l[4]
                    newLog.vendor = l[5]
                    newLog.cost = Float(l[6]) ?? 0.0
                    newCar.addToLogs(newLog)
                }
            }
        }
        
        // updateReminders(car: newCar, carIndex: i)
    }
}

// code borrowed from here https://stackoverflow.com/questions/32313938/parsing-csv-file-in-swift
private func getFileRows(fn: String, type: String, header: Bool) -> [String] {
    var data = ""

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
