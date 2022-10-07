//
//  Logbook.swift
//  Logbook
//
//  Created by sam on 2/26/22.
//

import SwiftUI

struct LogbookHistory: View {
    let saveAction: ()->Void
    
    @EnvironmentObject var appData : LogbookModel
    @EnvironmentObject var _state : AppState
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var isPresentingHistoryForm = false
    @State private var newLogRecord = Log()
    @State private var dateFilter = 0
    
    func notFiltered(dt: Date, filter: Int) -> Bool {
        return filter == 0 || (filter > 0 && dt > Calendar.current.date(byAdding: .month, value: -filter, to: Date())! )
    }
    
    var body: some View {
        if (appData.cars.count == 0) {
            Text("You have not added any cars in your Logbook.\nAdd a car in the [Cars] tab.")
                .foregroundColor(.gray)
                .font(.subheadline)
                .navigationTitle("Logbook History")
        } else {
            VStack {
                Section {
                    HStack {
                        Text("Filter")
                            .bold()
                            .foregroundColor(.orange)
                        Picker(selection: $dateFilter, label: Text("")) {
                            Text("3 months").tag(3)
                            Text("6 months").tag(6)
                            Text("One year").tag(12)
                            Text("All").tag(0)
                        }.pickerStyle(.segmented)
                    } .font(.caption)
                        .padding(10)
                }
                
                List {
                    ForEach ($appData.cars) { $c in
                        Section (header: Text(c.make + " " + c.model).bold()) {
                            if (c.logs.count>0) {
                                ForEach($c.logs) { $rec in
                                    if notFiltered(dt: rec.date, filter: dateFilter) {
                                        NavigationLink(destination:LogForm(rec: $rec, carModel: c.model, addNewLog: false)) {
                                            LogRow(rec: rec)
                                        }
                                    } else {
                                        EmptyView()
                                    }
                                } .onDelete { indices in
                                    Log.remove(logs: &c.logs, logIndex: indices)
                                    MaintStatus.updateMaintStatusArray(cars: appData.cars, state: _state)
                                }
                            } else {
                                Text("No logs recorded.")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                        }
                    }
                } .navigationTitle("Logbook History")
                    .toolbar {
                        Button(action: {
                            isPresentingHistoryForm = true
                            newLogRecord = Log.new()
                        }) { Image(systemName: "plus") }
                    } .sheet(isPresented: $isPresentingHistoryForm) {
                        NavigationView {
                            LogForm(rec: $newLogRecord, carModel: "", addNewLog: true)
                                .navigationTitle("Logbook")
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel") {
                                            isPresentingHistoryForm = false
                                        }
                                    }
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("Add") {
                                            Log.add(logs: &appData.cars[_state.c_car_idx].logs, newLog: newLogRecord)
                                            MaintStatus.updateMaintStatusArray(cars: appData.cars, state: _state)
                                            isPresentingHistoryForm = false
                                        }
                                    }
                                }
                        }
                    } .onChange(of: scenePhase) { phase in
                        if phase == .inactive { saveAction() }
                        MaintStatus.updateMaintStatusArray(cars: appData.cars, state: _state)
                    }
            }
        }
    }
}

struct Logbook_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogbookHistory(saveAction: {})
                .environmentObject(LogbookModel())
                .environmentObject(AppState())
        }
    }
}