//
//  LogbookApp.swift
//  Logbook
//
//  Created by sam on 2/26/22.
//

import SwiftUI
import os.log

@main
struct LogbookApp: App {
    @StateObject private var appData = LogbookModel()

    @State private var fileDataLoaded = false
    @State private var err: ErrorWrapper?

    var body: some Scene {
        WindowGroup {
            IntroScreen()
                .environmentObject(appData)
                .task {
                    if fileDataLoaded == false {
                        do {
                            appData.cars = try await loadData()
                            for i in appData.cars.indices {
                                Reminder.updateReminders(car: &appData.cars[i], carIndex: i)
                            }
                            fileDataLoaded = true
                        } catch {
                            appData.cars = []
                        }
                    }
                }
                .sheet(item: $err, onDismiss: { // encountered an error (err != nil), load the sample data
                    os_log("Error loading sample data.", log: appLog, type: .error)
                    appData.cars = loadSampleData()
                }) { wrapper in
                    ErrorView(errorWrapper: wrapper)
                }
        }
    }
}
