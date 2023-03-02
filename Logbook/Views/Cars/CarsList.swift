//
//  CarsList.swift
//  Logbook
//
//  Created by sam on 2/26/22.
//

import SwiftUI

struct CarsList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Car.make, ascending: true)],
                  animation: .default
    ) private var cars: FetchedResults<Car>
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var isPresentingCarForm = false
    @State private var carInfo = vCar()
    @State private var carServices = [vService()]
    
    var body: some View {
        VStack {
            if (cars.count == 0) {
                Text("You have not added any cars in your Logbook")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            } else {
                List {
                    ForEach(cars) { car in
                        NavigationLink(destination:CarForm(car: vCar())) { // ***** <---- need to pass 'car' here
                            CarRow(car: car)
                        }
                    } .onDelete { indices in
                        deleteCar(offsets: indices)
                        _g.shared.updateDueRemindersCount()
                    }
                }
            }
        } .navigationTitle("Cars")
            .toolbar {
                Button(action: {
                    isPresentingCarForm = true
                    carInfo = vCar()
                    carInfo.services = setupDefaultServices()
                }) {
                    Image(systemName: "plus")
                }
            } .sheet(isPresented: $isPresentingCarForm) {
                NavigationView {
                    CarForm(car: carInfo)
                        .navigationTitle("Car Details")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isPresentingCarForm = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    addCar()
                                    isPresentingCarForm = false
                                } .disabled(carInfo.make.isEmpty && carInfo.model.isEmpty)
                            }
                        }
                } .navigationViewStyle(.stack)
            } // .sheet
            .onChange(of: scenePhase) { _ in
                PersistenceController.shared.saveContext()
            }
    }
    
    private func addCar() {
        withAnimation {
            PersistenceController.shared.addNewCar(carInfo: carInfo)
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
        NavigationView {
        }
    }
}
