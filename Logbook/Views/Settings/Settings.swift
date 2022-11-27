//
//  Settings.swift
//  Logbook
//
//  Created by bugs on 7/19/22.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var appData : LogbookModel
    @EnvironmentObject var _state : AppState
    
    @State private var showingHelp = false
    
    @State private var nontificationEnabled = false
    @State private var number = 0.0
    @State private var number2 = 0.0
    
    var body: some View {
        Form {
            Section(header: Text("About Logbook")) {
                Button("Getting Started") {
                    showingHelp.toggle()
                }
            } .sheet(isPresented: $showingHelp) {
                Help()
            }
            
            Section (header: Text("Sample Data")){
                Button ("Load Sample Data") {
                    DispatchQueue.main.async {
                        appData.cars = Car.loadSampleData()
                        Reminder.updateRemindersArray(cars: appData.cars, state: _state)
                    }
                }
                Button ("Clear All Data") {
                    DispatchQueue.main.async {
                        appData.cars = []
                        AppState.resetState(state: _state)
                    }
                }
            }
        } .navigationTitle("Settings")
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(LogbookModel())
            .environmentObject(AppState())
    }
}
