//
//  LogbookHistory.swift
//  Logbook
//
//  Created by sam on 2/26/22.
//

import SwiftUI

struct LogbookHistory: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Car.make, ascending: true)],
                  animation: .default
    ) private var cars: FetchedResults<Car>
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var isPresentingHistoryForm = false
    @State private var dateFilter = 0
    
    func notFiltered(dt: Date, filter: Int) -> Bool {
        return filter == 0 || (filter > 0 && dt > Calendar.current.date(byAdding: .month, value: -filter, to: Date())! )
    }
    
    var body: some View {
        if (cars.count == 0) {
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
                    ForEach (cars) { c in
                        Section (header: Text(c.make_ + " " + c.model_).bold()) {
                            if (c.logsA.count>0) {
                                ForEach(c.logsA) { log in
                                    if notFiltered(dt: log.date_, filter: dateFilter) {
                                        NavigationLink(destination:LogForm(log: log, carModel: c.model_, addNewLog: false)) {
                                            LogRow(log: log)
                                        }
                                    } else {
                                        EmptyView()
                                    }
                                } .onDelete { indices in
                                    deleteLog(offsets: indices)
                                    //Reminder.updateReminders(car: &c, carIndex: _g.shared.c_car_idx)
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
                        }) { Image(systemName: "plus") }
                    } .sheet(isPresented: $isPresentingHistoryForm) {
                        NavigationView {
                            LogForm(log: Log(context: moc), carModel: "", addNewLog: true)
                                .navigationTitle("Logbook")
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel") {
                                            isPresentingHistoryForm = false
                                        }
                                    }
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("Add") {
                                            addLog()
                                            //Reminder.updateReminders(car: &cars[_g.shared.c_car_idx], carIndex: _g.shared.c_car_idx)
                                            isPresentingHistoryForm = false
                                        }
                                    }
                                }
                        }
                    } .onChange(of: scenePhase) { _ in
                        PersistenceController.shared.saveContext()
                    }
            }
        }
    }
    
    private func addLog() {    // ***** add logic to add all the car's details
        withAnimation {
            PersistenceController.shared.saveContext()
        }
    }
    
    private func deleteLog(offsets: IndexSet) {
        withAnimation {
            //offsets.map { logs[$0] }.forEach(moc.delete)
            PersistenceController.shared.saveContext()
        }
    }
    
}

struct Logbook_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        }
    }
}
