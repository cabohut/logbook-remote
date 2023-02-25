//
//  LogModel.swift
//  Logbook
//
//  Created by bugs on 7/4/22.
//

import Foundation
import SwiftUI
/*
struct Log99: Identifiable, Codable, Comparable {
    static func < (lhs: Log99, rhs: Log99) -> Bool {
        return lhs.date > rhs.date
    }
    
    var id: UUID = UUID()
    var date: Date = Date()
    var type: ServiceType = ServiceType.odometer
    var odometer: Int = 0
    var details: String = ""
    var vendor: String = ""
    var cost: Float = 0.0
    
    static func new() -> Log99 {
        return Log99()
    }
    
    static func add(logs: inout [Log99], newLog: Log99) {
        logs.append(newLog)
        logs = Log99.sortLogs(logs: logs)
    }

    static func remove(logs: inout [Log99], logIndex: IndexSet) {
        logs.remove(atOffsets: logIndex)
    }
    
    static func sortLogs(logs: [Log99]) -> [Log99] {
        return logs.sorted { $0.odometer > $1.odometer }
    }

    static func getLastLogByType (logs: [Log99], serviceType: ServiceType) -> Log99? {
        let filteredLogs = logs.filter {($0.type == serviceType) }
        let lastLog = filteredLogs.max {$0.date < $1.date}
        return lastLog
    }

    static func getLastLog (logs: [Log99]) -> Log99? {
        let lastLog = logs.max {$0.date < $1.date}
        return lastLog
    }
}

extension Log99 {
    var data: Log99 {
        Log99(date: date, type: type, odometer: odometer,details: details, vendor: vendor, cost: cost)
    }
    
    mutating func update(from data: Log99) {
        date = data.date
        type = data.type
        odometer = data.odometer
        details = data.details
        vendor = data.vendor
        cost = data.cost
    }
}
*/
