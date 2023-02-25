//
//  LogbookModel.swift
//  Logbook
//
//  Created by sam on 3/7/22.
//  Code from Scrumdinger sample app
//  https://developer.apple.com/tutorials/app-dev-training/persisting-data

import Foundation
import os.log
import SwiftUI

let DATA_FILE = "Logbook.data"
let OSLOG_FILE = "Logbook.log"
let CSV_DATA_FILE = "Logbook.csv"
let CARS_TEXT_FILE = "cars.csv"
let SERVICES_TEXT_FILE = "services.csv"
let LOGS_TEXT_FILE = "logs.csv"
let REMINDERS_TEXT_FILE = "reminders.csv"

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("Logbook").appendingPathExtension("plist")

let appLog = OSLog(subsystem: "com.cabohut.Logbook4cars", category: "Logbook")

class CarRemindersCount {
  var carID : UUID
  var count : Int
  
  init(carID : UUID, count: Int) {
      self.carID = carID
      self.count = count
  }
}

// Singleton class to hold global values
class _g {
    static let shared = _g()
    
    var c_car_idx = 0
    @Published var overdueCount = 0
    var remindersCounts: [CarRemindersCount] = []

    //Initializer access level change now
    private init(){        
    }

    func resetState() {
        c_car_idx = 0
        overdueCount = 0
        remindersCounts = []
    }
    
    func updateDueRemindersCount() {
        overdueCount = 0
        for r in remindersCounts {
            overdueCount += r.count
        }
    }
}

class LogbookModel: ObservableObject {
//    @Published var cars: [Car99] = []
    @Published var cars = []

    private static func oslogFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent(OSLOG_FILE)
    }
}

enum ServiceType: String, Identifiable, CaseIterable, Codable {
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
            return false
        case .battery:
            return false
        case .tuneup:
            return false
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
            return 0
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
            return 5000
        case .tires:
            return 48000
        case .rotate:
            return 0
        case .battery:
            return 0
        case .tuneup:
            return 36000
        case .brakes:
            return 36000
        case .smog:
            return 0
        case .alignment:
            return 0
        case .other:
            return 0
        }
    }
}
