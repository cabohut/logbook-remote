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
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            IntroScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        } .onChange(of: scenePhase) { _ in
            persistenceController.saveContext()
        }
    }
}
