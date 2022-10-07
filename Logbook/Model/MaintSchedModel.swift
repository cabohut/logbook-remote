//
//  MaintSchedModel.swift
//  Logbook
//
//  Created by bugs on 7/19/22.
//

import Foundation

struct MaintSched: Identifiable, Codable, Comparable {
    static func < (lhs: MaintSched, rhs: MaintSched) -> Bool {
        return lhs.maintMonths > rhs.maintMonths
    }
    
    var id: UUID = UUID()
    var maintType: LogType
    var maintMonths: Int
    var maintMiles: Int
    
    static func new() -> Car {
        return Car()
    }
    
    static func add(sched: inout [MaintSched], newCar: MaintSched) {
        sched.append(newCar)
    }
    
    static func remove(cars: inout [Car], carIndex: IndexSet) {
        cars.remove(atOffsets: carIndex)
    }    
}

extension MaintSched {
    var data: MaintSched {
        MaintSched(maintType: maintType, maintMonths: maintMonths, maintMiles: maintMiles)
    }
    
    mutating func update(from data: MaintSched) {
        maintType = data.maintType
        maintMonths = data.maintMonths
        maintMiles = data.maintMiles
    }
}

enum ServiceStatus {
    case isDue, isUpcoming, notScheduled
}
