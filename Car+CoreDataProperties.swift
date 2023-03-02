//
//  Car+CoreDataProperties.swift
//  Logbook
//
//  Created by bugs on 2/23/23.
//
//

import SwiftUI
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var license: String?
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var notes: String?
    @NSManaged public var overdueRemindersCount: Int32
    @NSManaged public var purchaseDate: Date?
    @NSManaged public var unique: String?
    @NSManaged public var upcomingRemindersCount: Int32
    @NSManaged public var vin: String?
    @NSManaged public var year: String?
    @NSManaged public var logs: NSSet?
    @NSManaged public var reminders: NSSet?
    @NSManaged public var services: NSSet?

    public var license_: String { license ?? "" }
    public var make_: String { make ?? "" }
    public var model_: String { model ?? "" }
    public var notes_: String { notes ?? "" }
    public var unique_: String { unique ?? "" }
    public var vin_: String { vin ?? "" }
    public var year_: String { year ?? "" }
    public var purchaseDate_: Date { purchaseDate ?? Date() }

    public var logsA: [Log] {
        let logsSet = logs as? Set<Log> ?? []
        return logsSet.sorted { $0.date_ < $1.date_ }
    }

    public var servicesA: [Service] {
        let servicesSet = services as? Set<Service> ?? []
        return servicesSet.sorted { $0.serviceType_ < $1.serviceType_ }
    }

    public var remindersA: [Reminder] {
        let remindersSet = reminders as? Set<Reminder> ?? []
        return remindersSet.sorted { $0.dateDue < $1.dateDue }
    }

}

// MARK: Generated accessors for logs
extension Car {

    @objc(addLogsObject:)
    @NSManaged public func addToLogs(_ value: Log)

    @objc(removeLogsObject:)
    @NSManaged public func removeFromLogs(_ value: Log)

    @objc(addLogs:)
    @NSManaged public func addToLogs(_ values: NSSet)

    @objc(removeLogs:)
    @NSManaged public func removeFromLogs(_ values: NSSet)

}

// MARK: Generated accessors for reminders
extension Car {

    @objc(addRemindersObject:)
    @NSManaged public func addToReminders(_ value: Reminder)

    @objc(removeRemindersObject:)
    @NSManaged public func removeFromReminders(_ value: Reminder)

    @objc(addReminders:)
    @NSManaged public func addToReminders(_ values: NSSet)

    @objc(removeReminders:)
    @NSManaged public func removeFromReminders(_ values: NSSet)

}

// MARK: Generated accessors for services
extension Car {

    @objc(addServicesObject:)
    @NSManaged public func addToServices(_ value: Service)

    @objc(removeServicesObject:)
    @NSManaged public func removeFromServices(_ value: Service)

    @objc(addServices:)
    @NSManaged public func addToServices(_ values: NSSet)

    @objc(removeServices:)
    @NSManaged public func removeFromServices(_ values: NSSet)

}

extension Car : Identifiable {

}
