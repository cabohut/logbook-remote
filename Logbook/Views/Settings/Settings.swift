//
//  Settings.swift
//  Logbook
//
//  Created by bugs on 7/19/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct Settings: View {
    @EnvironmentObject var appData : LogbookModel

    @State private var showingHelp = false

    private static func dataFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent(DATA_FILE)
    }

    var body: some View {
        Form {
            Section(header: Text("About Logbook")) {
                Button("Getting Started") {
                    showingHelp.toggle()
                }
            } .sheet(isPresented: $showingHelp) {
                Help()
            }

            Section (header: Text("Import/Export")){
                Button ("Export data to text file") {
                    DispatchQueue.main.async {
                        _g.shared.resetState()
                        Car.exportTextData(cars: appData.cars)
                    }
                }
            }
            
            Section (header: Text("Sample Data")){
                Button ("Load Sample Data") {
                    DispatchQueue.main.async {
                        _g.shared.resetState()
                        appData.cars = Car.loadSampleData()
                    }
                }
                
                Button ("Clear All Data") {
                    DispatchQueue.main.async {
                        appData.cars = []
                        _g.shared.resetState()
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
    }
}
