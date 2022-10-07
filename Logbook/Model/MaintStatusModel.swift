//
//  MaintStatusModel.swift
//  Logbook
//
//  Created by bugs on 8/1/22.
//

import Foundation

struct MaintStatus: Identifiable, Comparable {
    static func < (lhs: MaintStatus, rhs: MaintStatus) -> Bool {
        return lhs.dateDue < rhs.dateDue
    }

    var id: UUID = UUID()
    var carIdx: Int = 0
    var serviceType: LogType = .other
    var dateStatus: ServiceStatus = .notScheduled
    var milesStatus: ServiceStatus = .notScheduled
    var dateDue : Double = 0
    var daysUntilDue : Int = 0
    var milesDue : Int = 0
    var milesUntilDue : Int = 0
    
    static func new() -> MaintStatus {
        let newRec = MaintStatus()
        return newRec
    }

    static func add(maintStatus: inout [MaintStatus], statusRec: MaintStatus) {
        maintStatus.append(statusRec)
    }

    static func updateMaintStatusArray (cars: [Car], state: AppState) {
        AppState.resetState(state: state)

        for i in cars.indices {
            for m in cars[i].maint {
                var mStatus = MaintStatus.new()
                self.checkMaintStatus(car: cars[i], maintRec: m, mStatus: &mStatus)
                mStatus.carIdx = i
                mStatus.serviceType = m.maintType
                
                if (mStatus.dateStatus == .isDue || mStatus.milesStatus == .isDue) {
                    state.overdueCount += 1
                    state.maintStatus.append(mStatus)
                }

                if (mStatus.dateStatus == .isUpcoming && mStatus.milesStatus == .isUpcoming) {
                    state.upcomingCount += 1
                    state.maintStatus.append(mStatus)
                }
            }
        }
        
        state.maintStatus = state.maintStatus.sorted()
    }

    static func checkMaintStatus (car: Car, maintRec: MaintSched, mStatus: inout MaintStatus) {
        // Need to get the last time the service (maintType) was performed or if it is the first
        // time for that service then get the date and odometer of the last maintenance. App should
        // prompt the user to add an odometer log with date and milages (in case of a used car)
        var lastLog = Log.getLastLogByType(logs: car.logs, logType: maintRec.maintType)
        if lastLog == nil {  // no log for LogType was found
            lastLog = Log.new()
            lastLog?.date = car.purchaseDate
            lastLog?.odometer = 0
        }

        let carLastLog = car.logs.max { $0.odometer < $1.odometer }
        let lastMilages = carLastLog?.odometer ?? 0
        
        if maintRec.maintMonths > 0 {
            let dateSchedInSeconds = maintRec.maintMonths * Int(60 * 60 * 24 * 30.4369)
            mStatus.dateDue = lastLog!.date.timeIntervalSince1970 + TimeInterval(dateSchedInSeconds)
            
            mStatus.daysUntilDue = Int((mStatus.dateDue - Date().timeIntervalSince1970) / 86400)
            if mStatus.daysUntilDue < 0 && mStatus.dateDue > 0 {
                mStatus.dateStatus = .isDue
            } else {
                mStatus.dateStatus = .isUpcoming
            }
            mStatus.dateStatus = (mStatus.dateStatus == .isDue || mStatus.milesStatus == .isDue) ? .isDue : mStatus.dateStatus
        }
        
        if maintRec.maintMiles > 0 {
            mStatus.milesDue = lastLog!.odometer + maintRec.maintMiles * 1000
            mStatus.milesUntilDue = mStatus.milesDue - lastMilages
            if mStatus.milesUntilDue < 0 && mStatus.milesDue > 0 {
                mStatus.milesStatus = .isDue
            } else {
                mStatus.milesStatus = .isUpcoming
            }
            mStatus.milesStatus = (mStatus.milesStatus == .isDue || mStatus.milesStatus == .isDue) ? .isDue : mStatus.milesStatus
        }
    }
}
