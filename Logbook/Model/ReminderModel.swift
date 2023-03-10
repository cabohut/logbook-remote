//
//  ReminderModel.swift
//  Logbook
//
//  Created by bugs on 11/27/22.
//

import Foundation

/*
struct Reminder99: Identifiable, Codable, Comparable {
    static func < (lhs: Reminder99, rhs: Reminder99) -> Bool {
        return lhs.dateDue < rhs.dateDue
    }

    var id: UUID = UUID()
    var serviceType: ServiceType = .other
    var dateStatus: ServiceStatus = .notScheduled
    var milesStatus: ServiceStatus = .notScheduled
    var dateDue : Double = 0
    var daysUntilDue : Int = 0
    var milesDue : Int = 0
    var milesUntilDue : Int = 0
    
    static func new() -> Reminder99 {
        return Reminder99()
    }

    static func add(reminders: inout [Reminder99], reminder: Reminder99) {
        reminders.append(reminder)
    }

    static func updateReminders (car: inout Car99, carIndex: Int) {
        // clear reminders for this car
        Car99.clearReminders(car: &car)
        
        for s in car.services {
            var reminder = Reminder99.new()
            self.checkServiceStatus(car: car, service: s, reminder: &reminder)
            
            if (reminder.dateStatus == .isDue || reminder.milesStatus == .isDue) {
                car.overdueRemindersCount += 1

                reminder.serviceType = s.serviceType
                Reminder99.add(reminders: &car.reminders, reminder: reminder)
            }
            
            if (reminder.dateStatus == .isUpcoming && reminder.milesStatus == .isUpcoming) {
                car.upcomingRemindersCount += 1

                reminder.serviceType = s.serviceType
                Reminder99.add(reminders: &car.reminders, reminder: reminder)
            }
        }
        
        car.reminders = car.reminders.sorted()
        
        let idx = _g.shared.remindersCounts.firstIndex(where: { $0.carID == car.id }) ?? -1
        if idx >= 0 {
            _g.shared.remindersCounts[idx].count = car.reminders.count
        } else {
            let c = CarRemindersCount.init(carID: car.id, count: car.reminders.count)
            _g.shared.remindersCounts.append(c)
        }

        _g.shared.updateDueRemindersCount()
    }

    static func checkServiceStatus (car: Car99, service: Service99, reminder: inout Reminder99) {
        if !service.maintEnabled {
            return
        }
        
        // Need to get the last time the service (serviceType) was performed or if it is the first
        // time for that service then get the date and odometer of the last maintenance. App should
        // prompt the user to add an odometer log with date and milages (in case of a used car)
        
        var lastLog = Log99.getLastLogByType(logs: car.logs, serviceType: service.serviceType)
        if lastLog == nil {  // no log for LogType was found
            lastLog = Log99.new()
            lastLog?.date = car.purchaseDate
            lastLog?.odometer = 0
        }

        let carLastLog = car.logs.max { $0.odometer < $1.odometer }
        let lastMilages = carLastLog?.odometer ?? 0
        
        if service.maintMonths > 0 {
            let dateSchedInSeconds = service.maintMonths * Int(60 * 60 * 24 * 30.4369)
            reminder.dateDue = lastLog!.date.timeIntervalSince1970 + TimeInterval(dateSchedInSeconds)
            
            reminder.daysUntilDue = Int((reminder.dateDue - Date().timeIntervalSince1970) / 86400)
            if reminder.daysUntilDue < 0 && reminder.dateDue > 0 {
                reminder.dateStatus = .isDue
            } else {
                reminder.dateStatus = .isUpcoming
            }
            reminder.dateStatus = (reminder.dateStatus == .isDue || reminder.milesStatus == .isDue) ? .isDue : reminder.dateStatus
        }
        
        if service.maintMiles > 0 {
            reminder.milesDue = lastLog!.odometer + service.maintMiles
            reminder.milesUntilDue = reminder.milesDue - lastMilages
            if reminder.milesUntilDue < 0 && reminder.milesDue > 0 {
                reminder.milesStatus = .isDue
            } else {
                reminder.milesStatus = .isUpcoming
            }
            reminder.milesStatus = (reminder.milesStatus == .isDue || reminder.milesStatus == .isDue) ? .isDue : reminder.milesStatus
        }
    }
}

extension Reminder99 {
    var data: Reminder99 {
        Reminder99(serviceType: serviceType, dateStatus: dateStatus, milesStatus: milesStatus, dateDue: dateDue, daysUntilDue: daysUntilDue, milesDue: milesDue, milesUntilDue: milesUntilDue)
    }
    
    mutating func update(from data: Reminder99) {
        serviceType = data.serviceType
        dateStatus = data.dateStatus
        milesStatus = data.milesStatus
        dateDue = data.dateDue
        daysUntilDue = data.daysUntilDue
        milesDue = data.milesDue
        milesUntilDue = data.milesUntilDue
    }
}

*/
