//
//  CarForm.swift
//  Logbook
//
//  Created by bugs on 5/20/22.
//

import SwiftUI

struct CarForm: View {
    @State var car: vCar
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.isPresented) var isPresented
    
    @State private var maintenanceMode = 0
    @State private var maintMode = true
    @FocusState var isInputActive: Bool
    
    @State private var maintEnabled: Bool = true
    
    var body: some View {
        List {
            Section (header: Text(car.make + " " + car.model).bold()) {
                TextField("Year", text: $car.year)
                    .keyboardType(.numberPad)
                TextField("Make", text: $car.make)
                TextField("Model", text: $car.model)
                TextField("License Plate Number", text: $car.license)
                TextField("VIN", text: $car.vin)
                DatePicker("Purchase Date", selection: $car.purchaseDate, displayedComponents: .date)
            }
            
            Section (header: Text("Maintenance Schedule Cadence").bold()) {
                Text("Enter the recommended maintenance schedule for each service. Use the reminder icon to enable (orang) or disable (gray) reminders for each service.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                HStack {
                    Text("Service")
                        .bold()
                        .frame(width: 100, alignment: .leading)
                    Spacer()
                    Text("Months")
                        .bold()
                        .frame(width: 70)
                    Text("Miles")
                        .bold()
                        .frame(width: 70)
                } .foregroundColor(.orange)
                    .font(.subheadline)
                
                ForEach (car.services) { s in
                    if (s.serviceType != "Odometer" && s.serviceType != "Gas") {
                        HStack {
                            /*
                             // ***** fix enable, value for each service should be different
                             Toggle(isOn: $maintEnabled, label: { Text(s.serviceType.toUnwrapped(defaultValue: "").capitalized) })
                             //Toggle(isOn: s.maintEnabled.toUnwrapped(defaultValue: false), label: { Text(s.serviceType_.capitalized) })
                             //Toggle(isOn: $maintEnabled, label: { Text(s.serviceType_.capitalized) })
                             .toggleStyle(CheckboxStyle())
                             .onChange(of: maintEnabled) { value in
                             //Reminder.updateReminders(car: &car, carIndex: _g.shared.c_car_idx)
                             if !s.maintEnabled {
                             s.maintMonths = 0
                             s.maintMiles = 0
                             }
                             }
                             */
                            
                            Spacer()
                            
                            // maint months
                            TextField("", text: Binding (
                                get: { s.maintMonths != 0 ? String(s.maintMonths) : "" },
                                set: { s.maintMonths = Int32($0) ?? 0 }
                            ))
                            .num_field(enabled: s.maintEnabled)
                            .focused($isInputActive)
                            .onChange(of: s.maintMonths) { value in
                                //Reminder.updateReminders(car: &car, carIndex: _g.shared.c_car_idx)
                            }
                            
                            // maint miles
                            TextField("", text: Binding(
                                get: { s.maintMiles != 0 ? String(s.maintMiles) : "" },
                                set: { s.maintMiles = Int32($0) ?? 0 }
                            ))
                            .num_field(enabled: s.maintEnabled)
                            .focused($isInputActive)
                            .onChange(of: s.maintMiles) { value in
                                //Reminder.updateReminders(car: &car, carIndex: _g.shared.c_car_idx)
                            }
                        } .frame(maxWidth: .infinity)
                    } else {
                        EmptyView()
                    }
                } // ForEach
            } // Section
        } .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        isInputActive = false
                    }
                }
            }
    }
    
    private func updateCar() {   // ***** add logic to update car details
        withAnimation {
            let newCar = Car(context: moc)
            newCar.make = "zzzz"
            PersistenceController.shared.saveContext()
        }
    }
}

struct CarForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //CarForm(car: .constant(Car()))
        }
    }
}
