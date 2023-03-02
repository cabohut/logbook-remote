//
//  ServiceModel.swift
//  Logbook
//
//  Created by bugs on 7/19/22.
//

import Foundation
import SwiftUI

enum ServiceStatus: String, Codable {
    case isDue = "Is Due"
    case isUpcoming = "Is Upcoming"
    case notScheduled = "Not Scheduled"
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
    func maintDateDefault() -> Int32 {
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
    func maintMilesDefault() -> Int32 {
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
