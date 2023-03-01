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

    @State private var car_selection : Int = 0
    
    @Environment(\.isPresented) var isPresented
    
    var body: some View {
        List {
            if addNewLog {
                Section {
                    Picker("Car", selection: $car_selection) {
                        ForEach(0..<cars.count, id: \.self) { i in
                            Text(cars[i].make_ + " " + cars[i].model_)
                        }
                    } .onChange(of: car_selection) { newValue in
                        _g.shared.c_car_idx = newValue
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
                        Text(t.rawValue.capitalized).tag(t)
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
            if !newValue {
                // Reminder99.updateReminders(car: &appData.cars[_g.shared.c_car_idx], carIndex: _g.shared.c_car_idx)
            }
        }
    }
}

struct LogForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //LogForm(rec: .constant(Log()), carModel: "", addNewLog: false)
        }
    }
}
