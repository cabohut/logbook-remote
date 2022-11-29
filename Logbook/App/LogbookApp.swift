//
//  LogbookApp.swift
//  Logbook
//
//  Created by sam on 2/26/22.
//

import SwiftUI

@main
struct LogbookApp: App {
    @StateObject private var appData = LogbookModel()
    @StateObject private var _state = AppState()

    @State private var fileDataLoaded = false
    @State private var err: ErrorWrapper?

    var body: some Scene {
        WindowGroup {
            IntroScreen()
                .environmentObject(appData)
                .environmentObject(_state)
                .task {
                    if fileDataLoaded == false {
                        do {
                            appData.cars = try await LogbookModel.load()
                            for i in appData.cars.indices {
                                Reminder.updateReminders(car: &appData.cars[i], state: _state)
                            }
                            fileDataLoaded = true
                        } catch {
                            appData.cars = []
                        }
                    }
                }
                .sheet(item: $err, onDismiss: { // encountered an error (err != nil), load the sample data
                    appData.cars = Car.loadSampleData()
                    for i in 0..<appData.cars.count {
                        Reminder.updateReminders(car: &appData.cars[i], state: _state)
                    }
                }) { wrapper in
                    ErrorView(errorWrapper: wrapper)
                }
        }
    }
}
