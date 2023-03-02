//
//  LogbookForm.swift
//  Logbook
//
//  Created by sam on 3/2/22.
//

import SwiftUI

struct LogForm: View {
    @ObservedObject var log: Log
    var carModel : String
    var addNewLog : Bool
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Car.make, ascending: true)],
                  animation: .default
    ) private var cars: FetchedResults<Car>

    @State private var selectedCar = Car()
    
    @Environment(\.isPresented) var isPresented
    
    var body: some View {
        List {
            if addNewLog {
                Section {
                    Picker("Car", selection: $selectedCar) {
                        ForEach(cars, id: \.id) { car in
                            Text(car.make_ + " " + car.model_).tag(car)
                        }
                    } .onChange(of: selectedCar) { newValue in
                        let _ = print("car selection changed: newValue = \(newValue.make_)")
                        //_g.shared.c_car_idx = newValue
                    }
                }
            }
            
            Section (header: Text(carModel)){
                HStack {
                    Text("Date")
                    DatePicker("", selection: $log.date.unwrapped(d: Date()), displayedComponents: .date)
                } 

                Picker("Service Type", selection: $log.serviceType.unwrapped(d: "")) {
                    ForEach(ServiceType.allCases) { t in
                        Text(t.rawValue.capitalized).tag(t as ServiceType)
                    }
                }

                TextField("Odometer", text: Binding(
                    get: { log.odometer != 0 ? String(log.odometer) : "" },
                    set: { log.odometer = Int32($0) ?? 0 }
                ))
                    .keyboardType(.numberPad)

                TextField("Total Cost", value: $log.cost, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            
            Section (header: Text("Vendor & Service Details")){
                TextField("Vendor", text: $log.vendor.unwrapped(d: ""))
                TextField("Details", text: $log.details.unwrapped(d: ""))
            }

        } .onChange(of: isPresented) { newValue in
            let _ = print("log data changed: selectedCar = \(selectedCar)")
            if !newValue {
                // Reminder99.updateReminders(car: &appData.cars[_g.shared.c_car_idx], carIndex: _g.shared.c_car_idx)
            }
        }
    }
}

struct LogForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LogForm(log: Log(), carModel: "", addNewLog: false)
        }
    }
}
