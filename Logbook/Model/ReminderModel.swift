//
//  ReminderModel.swift
//  Logbook
//
//  Created by bugs on 8/1/22.
//

import Foundation

struct Reminder: Identifiable, Comparable {
    static func < (lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.dateDue < rhs.dateDue
    }

    var id: UUID = UUID()
    var carIdx: Int = 0
    var serviceType: ServiceType = .other
    var dateStatus: ServiceStatus = .notScheduled
    var milesStatus: ServiceStatus = .notScheduled
    var dateDue : Double = 0
    var daysUntilDue : Int = 0
    var milesDue : Int = 0
    var milesUntilDue : Int = 0
    
    static func new() -> Reminder {
        let newRec = Reminder()
        return newRec
    }

    static func add(reminders: inout [Reminder], statusRec: Reminder) {
        reminders.append(statusRec)
    }

    static func updateRemindersArray (cars: [Car], state: AppState) {
        AppState.resetState(state: state)

        for i in cars.indices {
            for s in cars[i].services {
                var reminder = Reminder.new()
                self.checkMaintStatus(car: cars[i], service: s, reminder: &reminder)
                reminder.carIdx = i
                reminder.serviceType = s.serviceType
                
                if (reminder.dateStatus == .isDue || reminder.milesStatus == .isDue) {
                    state.overdueCount += 1
                    state.reminders.append(reminder)
                }

                if (reminder.dateStatus == .isUpcoming && reminder.milesStatus == .isUpcoming) {
                    state.upcomingCount += 1
                    state.reminders.append(reminder)
                }
            }
        }
        
        state.reminders = state.reminders.sorted()
    }

    static func checkMaintStatus (car: Car, service: Service, reminder: inout Reminder) {
        // Need to get the last time the service (serviceType) was performed or if it is the first
        // time for that service then get the date and odometer of the last maintenance. App should
        // prompt the user to add an odometer log with date and milages (in case of a used car)
        
        if !service.maintEnabled {
            return
        }
        
        var lastLog = Log.getLastLogByType(logs: car.logs, serviceType: service.serviceType)
        if lastLog == nil {  // no log for LogType was found
            lastLog = Log.new()
            lastLog?.date = car.purchaseDate
            lastLog?.odometer = 0
        }

        let carLastLog = car.logs.max { $0.odometer < $1.odometer }
        let lastMilages = carLastLog?.odometer ?? 0
        
        if service.maintMonths > 0 && service.maintEnabled {
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
        
        if service.maintMiles > 0  && service.maintEnabled {
            reminder.milesDue = lastLog!.odometer + service.maintMiles * 1000
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
