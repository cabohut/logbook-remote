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

    @State private var fileDataLoaded = false
    @State private var err: ErrorWrapper?

    var body: some Scene {
        WindowGroup {
            IntroScreen()
                .environmentObject(appData)
                .task {
                    if fileDataLoaded == false {
                        do {
                            appData.cars = try await LogbookModel.load()
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
                    appData.cars = Car.loadSampleData()
                }) { wrapper in
                    ErrorView(errorWrapper: wrapper)
                }
        }
    }
}
