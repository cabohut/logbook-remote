//
//  LogModel.swift
//  Logbook
//
//  Created by bugs on 7/4/22.
//

import Foundation
import SwiftUI

struct Log: Identifiable, Codable, Comparable {
    static func < (lhs: Log, rhs: Log) -> Bool {
        return lhs.date > rhs.date
    }
    
    var id: UUID = UUID()
    var date: Date = Date()
    var type: LogType = LogType.odometer
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

    static func getLastLogByType (logs: [Log], logType: LogType) -> Log? {
        let filteredLogs = logs.filter {($0.type == logType) }
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

enum LogType: String, Identifiable, CaseIterable, Codable {
    var id: String { self.rawValue }

    case gas = "Gas"
    case odometer = "Odometer"
    case oil = "Oil Change"
    case tires = "New Tires"
    case rotate = "Rotate Tires"
    case battery = "New Battery"
    case tuneup = "Tune Up"
    case brakes = "Brakes"
    case smog = "Smog Check"
    case alignment = "Alignment"
    case other = "Other"
    
    // MARK: - imgs returns the image for the LogRow form
    func img() -> Image {
        switch self {
        case .gas:
            return Image(systemName: "fuelpump")
        case .odometer:
            return Image("service.odometer")
        case .oil:
            return Image("service.oil")
        case .tires:
            return Image("service.tires")
        case .rotate:
            return Image("service.rotate-tires")
        case .battery:
            return Image(systemName: "minus.plus.batteryblock")
        case .tuneup:
            return Image(systemName: "bookmark.circle")
        case .brakes:
            return Image("service.brakes")
        case .smog:
            return Image(systemName: "checkmark.seal")
        case .alignment:
            return Image("service.alignment")
        case .other:
            return Image(systemName: "wrench")
        }
    }
    
    // MARK: - maintEnabledDefault returns the default maintenance tracking status (true or false)
    func maintEnabledDefault() -> Bool {
        switch self {
        case .gas:
            return false
        case .odometer:
            return false
        case .oil:
            return true
        case .tires:
            return true
        case .rotate:
            return true
        case .battery:
            return true
        case .tuneup:
            return true
        case .brakes:
            return true
        case .smog:
            return false
        case .alignment:
            return false
        case .other:
            return false
        }
    }
    
    // MARK: - maintDateDefault returns the default number of months for each service (0 = n/a)
    func maintDateDefault() -> Int {
        switch self {
        case .gas:
            return 0
        case .odometer:
            return 0
        case .oil:
            return 6
        case .tires:
            return 0
        case .rotate:
            return 0
        case .battery:
            return 36
        case .tuneup:
            return 0
        case .brakes:
            return 0
        case .smog:
            return 24
        case .alignment:
            return 0
        case .other:
            return 0
        }
    }
    
    // MARK: - maintMilesDefault returns the default number of miles for each service (0 = n/a)
    func maintMilesDefault() -> Int {
        switch self {
        case .gas:
            return 0
        case .odometer:
            return 0
        case .oil:
            return 5
        case .tires:
            return 40
        case .rotate:
            return 5
        case .battery:
            return 0
        case .tuneup:
            return 36
        case .brakes:
            return 36
        case .smog:
            return 0
        case .alignment:
            return 0
        case .other:
            return 0
        }
    }
}
