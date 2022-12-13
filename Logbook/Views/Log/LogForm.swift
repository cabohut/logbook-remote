//
//  LogbookForm.swift
//  Logbook
//
//  Created by sam on 3/2/22.
//

import SwiftUI

struct LogForm: View {
    @Binding var rec: Log
    var carModel : String
    var addNewLog : Bool
    @State private var car_selection : Int = 0
    
    @Environment(\.isPresented) var isPresented
    @EnvironmentObject var appData : LogbookModel
    
    var body: some View {
        List {
            if addNewLog {
                Section {
                    Picker("Car", selection: $car_selection) {
                        ForEach(0..<appData.cars.count, id: \.self) { i in
                            Text(appData.cars[i].make + " " + appData.cars[i].model)
                        }
                    } .onChange(of: car_selection) { newValue in
                        _g.shared.c_car_idx = newValue
                    }
                }
            }
            
            Section (header: Text(carModel)){
                HStack {
                    Text("Date")
                    DatePicker("", selection: $rec.date,displayedComponents: .date)
                } 

                Picker("Service Type", selection: $rec.type) {
                    ForEach(ServiceType.allCases) { t in
                        Text(t.rawValue.capitalized).tag(t)
                    }
                }

                TextField("Odometer", text: Binding(
                    get: { rec.odometer != 0 ? String(rec.odometer) : "" },
                    set: { rec.odometer = Int($0) ?? 0 }
                ))
                    .keyboardType(.numberPad)

                TextField("Total Cost", value: $rec.cost, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            
            Section (header: Text("Vendor & Service Details")){
                TextField("Vendor", text: $rec.vendor)
                TextField("Details", text: $rec.details)
            }
        } .onChange(of: isPresented) { newValue in
            if !newValue {
                Reminder.updateReminders(car: &appData.cars[_g.shared.c_car_idx], carIndex: _g.shared.c_car_idx)
            }
        }
    }
}

struct LogForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LogForm(rec: .constant(Log()), carModel: "", addNewLog: false)
        }
    }
}
