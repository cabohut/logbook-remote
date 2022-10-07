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
    
    @Environment(\.isPresented) var isPresented
    @EnvironmentObject var appData : LogbookModel
    @EnvironmentObject var _state : AppState
    
    var body: some View {
        List {
            if addNewLog {
                Section {
                    Picker("Car", selection: $_state.c_car_idx) {
                        ForEach(0..<appData.cars.count, id: \.self) { i in
                            Text(appData.cars[i].make + " " + appData.cars[i].model)
                        }
                    }
                }
            }
            
            Section (header: Text(carModel)){
                HStack {
                    Text("Date")
                    DatePicker("", selection: $rec.date,displayedComponents: [.date])
                } 

                Picker("Log Type", selection: $rec.type) {
                    ForEach(LogType.allCases) { t in
                        Text(t.rawValue.capitalized).tag(t)
                    }
                }
                
                TextField("Odometer", value: $rec.odometer, formatter: numFormatter)
                    .keyboardType(.numberPad)
                
                TextField("Total Cost", value: $rec.cost, formatter: currencyFormatter)
                    .keyboardType(.decimalPad)
            }
            
            Section (header: Text("Vendor & Service Details")){
                TextField("Vendor", text: $rec.vendor)
                TextField("Details", text: $rec.details)
            }
        } .onChange(of: isPresented) { newValue in
            if !newValue {
                MaintStatus.updateMaintStatusArray(cars: appData.cars, state: _state)
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
