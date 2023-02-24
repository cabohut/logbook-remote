//
//  Service+CoreDataProperties.swift
//  Logbook
//
//  Created by bugs on 2/23/23.
//
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var maintEnabled: Bool
    @NSManaged public var maintMiles: Int32
    @NSManaged public var maintMonths: Int32
    @NSManaged public var serviceType: String?
    @NSManaged public var car: Car?

}

extension Service : Identifiable {

}
