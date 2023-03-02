//
//  Settings.swift
//  Logbook
//
//  Created by bugs on 7/19/22.
//

import SwiftUI

struct Settings: View {
    @State private var showingHelp = false

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
                        //exportTextData(cars: appData.cars)
                    }
                }
            }
            
            Section (header: Text("Sample Data")){
                Button ("Load Sample Data") {
                    DispatchQueue.main.async {
                        _g.shared.resetState()
                        importData()
                    }
                }
                
                Button ("Clear All Data") {
                    DispatchQueue.main.async {
                        PersistenceController.shared.deleteAll()
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
    }
}
