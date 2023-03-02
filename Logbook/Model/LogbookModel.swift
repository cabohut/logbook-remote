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
