//
//  CoreDataHelpers.swift
//  Logbook
//
//  Created by bugs on 2/24/23.
//

import SwiftUI

func stringOf (s: String?) -> String {
    return s ?? ""
}

// needed to unwrap optional CoreData - https://stackoverflow.com/questions/68543882/cannot-convert-value-of-type-bindingstring-to-expected-argument-type-bindi
extension Binding {
     func unwrapped<T>(d: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? d }, set: { self.wrappedValue = $0 })
    }
}

extension Log {
    var serviceTypeE: ServiceType {
        get {
            return ServiceType(rawValue: self.serviceType_)!
        }
        set {
            self.serviceType = newValue.rawValue
        }
    }
}

extension Reminder {
    var serviceTypeE: ServiceType {
        get {
            return ServiceType(rawValue: self.serviceType_)!
        }
        set {
            self.serviceType = newValue.rawValue
        }
    }
}

extension Reminder {
    var dateServiceStatusE: ServiceStatus {
        get {
            return ServiceStatus(rawValue: self.dateServiceStatus_)!
        }
        set {
            self.dateServiceStatus = newValue.rawValue
        }
    }
}

extension Reminder {
    var milesServiceStatusE: ServiceStatus {
        get {
            return ServiceStatus(rawValue: self.milesServiceStatus_)!
        }
        set {
            self.milesServiceStatus = newValue.rawValue
        }
    }
}
