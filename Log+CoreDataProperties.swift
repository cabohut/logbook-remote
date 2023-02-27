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

    public var date_: Date { date ?? Date() }
    public var serviceType_: String { serviceType ?? "" }
    public var details_: String { details ?? "" }
    public var vendor_: String { vendor ?? "" }

}

extension Log : Identifiable {

}
