//
//  Log+CoreDataProperties.swift
//  Logbook
//
//  Created by bugs on 2/23/23.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var cost: Float
    @NSManaged public var date: Date?
    @NSManaged public var details: String?
    @NSManaged public var id: UUID?
    @NSManaged public var odometer: Int32
    @NSManaged public var serviceType: String?
    @NSManaged public var vendor: String?
    @NSManaged public var car: Car?

}

extension Log : Identifiable {

}
