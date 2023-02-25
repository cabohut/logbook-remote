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
                    ForEach(cars) { car in
                        NavigationLink(destination:CarForm(car: car)) {
                            CarRow(car: car)
                        }
                    } .onDelete { indices in
                        if indices.first != nil {
                            let idx = _g.shared.remindersCounts.firstIndex(where: { $0.carID == cars[indices.first!].id }) ?? -1
                            _g.shared.remindersCounts.remove(at: idx)
                        }
                        //Car.remove(cars: &cars, carIndex: indices) 
                        deleteCar(offsets: indices)
                        
                        _g.shared.updateDueRemindersCount()
                    }
                }
            }
        } .navigationTitle("Cars")
            .toolbar {
                Button(action: {
                    isPresentingCarForm = true
                    newCarRecord = Car(context: moc)
                }) {
                    Image(systemName: "plus")
                }
            } .sheet(isPresented: $isPresentingCarForm) {
                NavigationView {
                    CarForm(car: newCarRecord)
                        .navigationTitle("Car Details")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isPresentingCarForm = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    // Car.add(cars: &cars, newCar: newCarRecord)    // ***** <- add car
                                    addCar()
                                    isPresentingCarForm = false
                                } // .disabled(newCarRecord.make.isEmpty && newCarRecord.model.isEmpty)
                            }
                        }
                } .navigationViewStyle(.stack)
            } // .sheet
            .onChange(of: scenePhase) { _ in
                PersistenceController.shared.saveContext()
            }
    }
    
    private func addCar() {    // ***** add logic to add all the car's details
        withAnimation {
            let newCar = Car(context: moc)
            newCar.make = ""
            PersistenceController.shared.saveContext()
        }
    }

    private func deleteCar(offsets: IndexSet) {
        withAnimation {
            offsets.map { cars[$0] }.forEach(moc.delete)
            PersistenceController.shared.saveContext()
        }
    }

}

struct Cars_Previews: PreviewProvider {
    static var previews: some View {
        CarsList(saveAction: {})
            .environmentObject(LogbookModel())
    }
}
