//
//  LogModel.swift
//  Logbook
//
//  Created by bugs on 7/4/22.
//

import Foundation
import SwiftUI

struct Log99: Identifiable, Codable, Comparable {
    static func < (lhs: Log, rhs: Log) -> Bool {
        return lhs.date > rhs.date
    }
    
    var id: UUID = UUID()
    var date: Date = Date()
    var type: ServiceType = ServiceType.odometer
    var odometer: Int = 0
    var details: String = ""
    var vendor: String = ""
    var cost: Float = 0.0
    
    static func new() -> Log {
        return Log()
    }
    
    static func add(logs: inout [Log], newLog: Log) {
        logs.append(newLog)
        logs = Log.sortLogs(logs: logs)
    }

    static func remove(logs: inout [Log], logIndex: IndexSet) {
        logs.remove(atOffsets: logIndex)
    }
    
    static func sortLogs(logs: [Log]) -> [Log] {
        return logs.sorted { $0.odometer > $1.odometer }
    }

    static func getLastLogByType (logs: [Log], serviceType: ServiceType) -> Log? {
        let filteredLogs = logs.filter {($0.type == serviceType) }
        let lastLog = filteredLogs.max {$0.date < $1.date}
        return lastLog
    }

    static func getLastLog (logs: [Log]) -> Log? {
        let lastLog = logs.max {$0.date < $1.date}
        return lastLog
    }
}

extension Log {
    var data: Log {
        Log(date: date, type: type, odometer: odometer,details: details, vendor: vendor, cost: cost)
    }
    
    mutating func update(from data: Log) {
        date = data.date
        type = data.type
        odometer = data.odometer
        details = data.details
        vendor = data.vendor
        cost = data.cost
    }
}
