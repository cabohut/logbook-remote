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
    //@Binding var car: Car
    @ObservedObject var car: Car
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.isPresented) var isPresented
    
    @State private var maintenanceMode = 0
    @State private var maintMode = true
    @FocusState var isInputActive: Bool

    // car data
    @State private var year: String = ""
    @State private var make: String = ""
    @State private var model: String = ""
    @State private var license: String = ""
    @State private var vin: String = ""
    @State private var purchaseDate: Date = Date()
    @State private var notes: String = ""
    
    // service data
    @State private var serviceType: String = ""
    @State private var maintEnabled: Bool = true
    @State private var maintMonths: Int = 0
    @State private var maintMiles: Int = 0

    var body: some View {
        List {
            Section (header: Text(car.make_ + " " + car.model_).bold()) {
                TextField("Year", text: $year)
                    .keyboardType(.numberPad)
                    .onAppear {
                        year = car.year_
                        make = car.make_
                        model = car.model_
                        license = car.license_
                        vin = car.vin_
                        purchaseDate = car.purchaseDate_
                        notes = car.notes_
                    }
                TextField("Make", text: $make)
                TextField("Model", text: $model)
                TextField("License Plate Number", text: $license)
                TextField("VIN", text: $vin)
                DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
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
                
                Text("Services go here")
                let _ = print(car.servicesA.count)
                ForEach (car.servicesA) { s in
                    if (s.serviceType_ != "odometer" && s.serviceType_ != "gas") {
                        HStack {
                            /*
                            Toggle(isOn: $maintEnabled, label: {Text(s.serviceType_.rawValue.capitalized)})
                                .toggleStyle(CheckboxStyle())
                                .onAppear {
                                    serviceType = s.serviceType_
                                    maintEnabled = s.maintEnabled
                                    maintMonths = s.maintMonths
                                    maintMiles = s.maintMiles
                                }
                                .onChange(of: maintEnabled) { value in
                                    //Reminder.updateReminders(car: &car, carIndex: _g.shared.c_car_idx)
                                    if !maintEnabled {
                                        maintMonths = 0
                                        maintMiles = 0
                                    }
                                }
                            */
                            
                            Spacer()
                            
                            // maint months
                            TextField("", text: Binding (
                                get: { maintMonths != 0 ? String(maintMonths) : "" },
                                set: { maintMonths = Int($0) ?? 0 }
                            ))
                            .num_field(enabled: maintEnabled)
                            .focused($isInputActive)
                            .onChange(of: maintMonths) { value in
                                //Reminder.updateReminders(car: &car, carIndex: _g.shared.c_car_idx)
                            }
                            
                            // maint miles
                            TextField("", text: Binding(
                                get: { maintMiles != 0 ? String(maintMiles) : "" },
                                set: { maintMiles = Int($0) ?? 0 }
                            ))
                            .num_field(enabled: maintEnabled)
                            .focused($isInputActive)
                            .onChange(of: maintMiles) { value in
                                //Reminder.updateReminders(car: &car, carIndex: _g.shared.c_car_idx)
                            }
                        } .frame(maxWidth: .infinity)
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
