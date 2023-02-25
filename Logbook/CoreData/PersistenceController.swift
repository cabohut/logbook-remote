//
//  PersistenceController.swift
//  Logbook
//
//  Created by bugs on 2/23/23.
//

import CoreData
import os.log

struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()
    
    // Storage for Core Data
    let container : NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "LogbookModel") // else UnsafeRawBufferPointer with negative count
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error \(error), \(error.userInfo)")
            }
        })
    }
    
    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Companies
        let newCar = Car(context: viewContext)
        newCar.make = "Porsche"
        
        shared.saveContext()
        
        return controller
    }()
    

    func saveContext() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Handle errors in our database
                let nsError = error as NSError
                fatalError("Error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Car.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }

    func loadSampleData() {
         importData()
        /*
         for i in 0..<cars.count {
             print(i)
             //Reminder99.updateReminders(car: &cars[i], carIndex: i)
         }
         */
    }

    private func importData() {
        var rows: [String]
        
        // cars file
        rows = getFileRows(fn: "cars", type: "csv", header: true)
        for row in rows {
            let c = row.components(separatedBy: "\t")
            if c.count == 9 {
                let newCar = Car(context: viewContext)
                newCar.id = UUID()
                newCar.year = c[1]
                newCar.make = c[2]
                newCar.model = c[3]
                newCar.unique = c[4]
                newCar.license = c[5]
                newCar.vin = c[6]
                newCar.purchaseDate = convertDate(date: c[7])
                newCar.notes = c[8]
            }
        }
        
        // services file
        rows = getFileRows(fn: "services", type: "csv", header: true)
        for row in rows {
            let c = row.components(separatedBy: "\t")
            if c.count == 5 {
                let newService = Service(context: viewContext)
                newService.id = UUID()
                newService.serviceType = c[1]
                newService.maintEnabled = Bool(c[2]) ?? false
                newService.maintMonths = Int32(c[3]) ?? 0
                newService.maintMiles = Int32(c[4]) ?? 0
            }
        }
        
        // logs file
        rows = getFileRows(fn: "logs", type: "csv", header: true)
        for row in rows {
            let c = row.components(separatedBy: "\t")
            if c.count == 7 {
                let newLog = Log(context: viewContext)
                newLog.id = UUID()
                newLog.date = convertDate(date: c[1])
                newLog.serviceType = c[2]
                newLog.odometer = Int32(c[3]) ?? 0
                newLog.details = c[4]
                newLog.vendor = c[5]
                newLog.cost = Float(c[6]) ?? 0.0
            }
        }
        
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
}
