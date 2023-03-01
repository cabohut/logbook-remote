//
//  CarForm.swift
//  Logbook
//
//  Created by bugs on 5/20/22.
//

import SwiftUI

// custom modifier
// https://useyourloaf.com/blog/swiftui-custom-view-modifiers/
struct NumField: ViewModifier {
    let enabled: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(3)
            .padding(.horizontal, 5)
            .frame(width: 70)
            .multilineTextAlignment(.trailing)
            .overlay(RoundedRectangle(cornerRadius: 4.0)
                .strokeBorder(enabled ? .orange : Color.primary, style: StrokeStyle(lineWidth: enabled ? 0.2 : 0.05)))
            .foregroundColor(enabled ? Color.primary : .gray)
            .disabled(!enabled)
            .keyboardType(.numberPad)
            //.background(Color(0xF2F2F7, alpha: 0.1))
    }
}

extension View {
    func num_field(enabled: Bool = true) -> some View {
        modifier(NumField(enabled: enabled))
    }
}

struct CheckboxStyle: ToggleStyle {
    // https://www.appcoda.com/swiftui-toggle-style/
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .orange : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            
            configuration.label
        }
    }
}

struct CarForm: View {
    @ObservedObject var car: Car
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.isPresented) var isPresented
    
    @State private var maintenanceMode = 0
    @State private var maintMode = true
    @FocusState var isInputActive: Bool

    @State private var maintEnabled: Bool = true

    var svcs : [Service] {
        car.services?.allObjects as? [Service] ?? []
    }

    var body: some View {
        List {
            Section (header: Text(car.make_ + " " + car.model_).bold()) {
                TextField("Year", text: $car.year.unwrapped(d: ""))
                    .keyboardType(.numberPad)
                TextField("Make", text: $car.make.unwrapped(d: ""))
                TextField("Model", text: $car.model.unwrapped(d: ""))
                TextField("License Plate Number", text: $car.license.unwrapped(d: ""))
                TextField("VIN", text: $car.vin.unwrapped(d: ""))
                DatePicker("Purchase Date", selection: $car.purchaseDate.unwrapped(d: Date()), displayedComponents: .date)
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
                
                ForEach (svcs) { s in
                    if (s.serviceType_ != "Odometer" && s.serviceType_ != "Gas") {
                        HStack {
                            //Toggle(isOn: maintEnabled, label: Text("toggle me"))
                            /*
                            Toggle(isOn: maintEnabled (
                                get: { s.maintEnabled },
                                set: {
                                    s.maintEnabled = $0
                                    
                                })) { Text("label99") }
                             */
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
