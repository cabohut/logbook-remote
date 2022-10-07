//
//  Cars.swift
//  Logbook
//
//  Created by sam on 2/26/22.
//

import SwiftUI

struct CarsList: View {
    let saveAction: ()->Void
    
    @EnvironmentObject var appData : LogbookModel
    @EnvironmentObject var _state : AppState

    @Environment(\.scenePhase) private var scenePhase
    
    @State private var isPresentingCarForm = false
    @State private var newCarRecord = Car()
    
    var body: some View {
        VStack {
            if (appData.cars.count == 0) {
                Text("You have not added any cars in your Logbook")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            } else {
                List {
                    ForEach($appData.cars) { $rec in
                        NavigationLink(destination:CarForm(rec: $rec)) {
                            CarRow(rec: rec)
                        }
                    } .onDelete { indices in
                        Car.remove(cars: &appData.cars, carIndex: indices)
                        MaintStatus.updateMaintStatusArray(cars: appData.cars, state: _state)
                    }
                }
            }
        } .navigationTitle("Cars")
            .toolbar {
                Button(action: {
                    isPresentingCarForm = true
                    newCarRecord = Car.new()
                }) {
                    Image(systemName: "plus")
                }
            } .sheet(isPresented: $isPresentingCarForm) {
                NavigationView {
                    CarForm(rec: $newCarRecord)
                        .navigationTitle("Car Details")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isPresentingCarForm = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    Car.add(cars: &appData.cars, newCar: newCarRecord)
                                    MaintStatus.updateMaintStatusArray(cars: appData.cars, state: _state)
                                    isPresentingCarForm = false
                                } .disabled(newCarRecord.make.isEmpty && newCarRecord.model.isEmpty)
                            }
                        }
                } .navigationViewStyle(.stack)
            } // .sheet
            .onChange(of: scenePhase) { phase in
                if phase == .inactive { saveAction() }
                MaintStatus.updateMaintStatusArray(cars: appData.cars, state: _state)
            }
    }
}

struct Cars_Previews: PreviewProvider {
    static var previews: some View {
        CarsList(saveAction: {})
            .environmentObject(LogbookModel())
            .environmentObject(AppState())
    }
}
