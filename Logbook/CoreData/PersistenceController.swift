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
        
        self.saveContext()
        print("done deleting: number of cars")
    }
    
    func addNewCar(carInfo: vCar) {
        
        let newCar = Car(context: self.viewContext)
        newCar.id = UUID()
        newCar.year = carInfo.year
        newCar.make = carInfo.make
        newCar.model = carInfo.model
        newCar.unique = carInfo.make + " " + carInfo.model
        newCar.license = carInfo.license
        newCar.vin = carInfo.vin
        newCar.purchaseDate = carInfo.purchaseDate
        newCar.notes = carInfo.notes
        
        // services file
        for s in carInfo.services {
            let newService = Service(context: self.viewContext)
            newService.id = UUID()
            newService.serviceType = s.serviceType
            newService.maintEnabled = s.maintEnabled
            newService.maintMonths = s.maintMonths
            newService.maintMiles = s.maintMiles
            newCar.addToServices(newService)
        }
        
        self.saveContext()
    }
}
