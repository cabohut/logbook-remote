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

