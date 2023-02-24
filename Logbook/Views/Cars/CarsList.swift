//
//  CarsList.swift
//  Logbook
//
//  Created by sam on 2/26/22.
//

import SwiftUI

struct CarsList: View {
    let saveAction: ()->Void

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Car.make, ascending: true)],
                  animation: .default)
    private var cars: FetchedResults<Car>

    @Environment(\.scenePhase) private var scenePhase
    
    @State private var isPresentingCarForm = false
    @State private var newCarRecord = Car()
    
    var body: some View {
        VStack {
            if (cars.count == 0) {
                Text("You have not added any cars in your Logbook")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            } else {
                List {
                    ForEach($cars) { $rec in
                        NavigationLink(destination:CarForm(car: $rec)) {
                            CarRow(rec: rec)
                        }
                    } .onDelete { indices in
                        if indices.first != nil {
                            let idx = _g.shared.remindersCounts.firstIndex(where: { $0.carID == cars[indices.first!].id }) ?? -1
                            _g.shared.remindersCounts.remove(at: idx)
                        }
                        Car.remove(cars: &cars, carIndex: indices)    // ***** <- remove car

                        _g.shared.updateDueRemindersCount()
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
                    CarForm(car: $newCarRecord)
                        .navigationTitle("Car Details")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isPresentingCarForm = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    Car.add(cars: &cars, newCar: newCarRecord)    // ***** <- add car
                                    isPresentingCarForm = false
                                } .disabled(newCarRecord.make.isEmpty && newCarRecord.model.isEmpty)
                            }
                        }
                } .navigationViewStyle(.stack)
            } // .sheet
            .onChange(of: scenePhase) { _ in
                moc.saveContext()
            }
    }
}

struct Cars_Previews: PreviewProvider {
    static var previews: some View {
        CarsList(saveAction: {})
            .environmentObject(LogbookModel())
    }
}
