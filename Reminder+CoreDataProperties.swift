//
//  Reminder+CoreDataProperties.swift
//  Logbook
//
//  Created by bugs on 2/23/23.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var dateDue: Double
    @NSManaged public var dateServiceStatus: String?
    @NSManaged public var daysUntilDue: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var milesDue: Int32
    @NSManaged public var milesServiceStatus: String?
    @NSManaged public var milesUntilDue: Int32
    @NSManaged public var serviceType: String?
    @NSManaged public var car: Car?

}

extension Reminder : Identifiable {

}
