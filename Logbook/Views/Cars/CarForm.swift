//
//  CarForm.swift
//  Logbook
//
//  Created by bugs on 5/20/22.
//

import SwiftUI

struct CarForm: View {
    @Binding var rec: Car
    
    @Environment(\.isPresented) var isPresented
    @EnvironmentObject var appData : LogbookModel
    @EnvironmentObject var _state : AppState
    
    @State private var maintenanceMode = 0
    
    var body: some View {
        List {
            Section (header: Text(rec.make + " " + rec.model).bold()) {
                TextField("Year", text: $rec.year)
                    .keyboardType(.numberPad)
                TextField("Make", text: $rec.make)
                TextField("Model", text: $rec.model)
                TextField("License Plate Number", text: $rec.license)
                TextField("VIN", text: $rec.vin)
                DatePicker("Purchase Date", selection: $rec.purchaseDate,displayedComponents: [.date])
                TextField("Notes", text: $rec.notes)
            }

            Section (header: Text("Maintenance Schedule Cadence").bold()) {
                Text("Enter the recommended maintenance schedule. Leave the cadence value blank to turn off reminders for that category.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                

                HStack {
                    Text("Service")
                        .bold()
                        .frame(width: 100, alignment: .leading)
                    Spacer()
                    Text("Months")
                        .bold()
                        .frame(width: 60)
                    Text("Miles (K)")
                        .bold()
                        .frame(width: 60)
                } .foregroundColor(.orange)
                    .font(.subheadline)
                
                ForEach ($rec.maint) { $m in
                    if (m.maintType != .odometer && m.maintType != .gas) {
                        HStack {
                            Text(m.maintType.rawValue.capitalized)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            
                            TextField("", value: $m.maintMonths, formatter: numFormatter)
                                .padding(.horizontal, 5)
                                .modifier(_TextFieldModifier())
                                .frame(width: 60)
                                .keyboardType(.numberPad)
                            TextField("", value: $m.maintMiles, formatter: numFormatter)
                                .padding(.horizontal, 5)
                                .modifier(_TextFieldModifier())
                                .frame(width: 60)
                                .keyboardType(.numberPad)
                        } .frame(maxWidth: .infinity)
                    }
                }
            }
            
        } .navigationBarTitleDisplayMode(.inline)
        .onChange(of: isPresented) { newValue in
            if !newValue {
                MaintStatus.updateMaintStatusArray(cars: appData.cars, state: _state)
            }
        }
    }
}

struct CarForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CarForm(rec: .constant(Car()))
        }
    }
}
