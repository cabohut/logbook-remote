//
//  CarForm.swift
//  Logbook
//
//  Created by bugs on 5/20/22.
//

import SwiftUI

// custom modifier
struct _TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(3)
            .padding(.horizontal, 5)
            .frame(width: 60)
            .multilineTextAlignment(.trailing)
            .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.primary, style: StrokeStyle(lineWidth: 0.1)))
            //.background(Color(0xF2F2F7, alpha: 0.3))
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
    @Binding var car: Car
    
    @Environment(\.isPresented) var isPresented
    @EnvironmentObject var appData : LogbookModel
    
    @State private var maintenanceMode = 0
    @State var maintMode = true
    
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
                        .frame(width: 60)
                    Text("Miles (K)")
                        .bold()
                        .frame(width: 60)
                } .foregroundColor(.orange)
                    .font(.subheadline)
                
                ForEach ($car.services) { $s in
                    if (s.serviceType != .odometer && s.serviceType != .gas) {
                        HStack {
                            Toggle(isOn: $s.maintEnabled, label: {Text(s.serviceType.rawValue.capitalized)})
                                .toggleStyle(CheckboxStyle())
                                .onChange(of: s.maintEnabled) { value in
                                    Reminder.updateReminders(car: &car, carIndex: _g.shared.c_car_idx)
                                    if !s.maintEnabled {
                                        s.maintMonths = 0
                                        s.maintMiles = 0
                                    }
                                }
                            
                            Spacer()
                            
                            // maint months
                            TextField("", text: Binding (
                                get: { String(s.maintMonths) },
                                set: { s.maintMonths = Int($0) ?? 0 }
                            ))
                            .modifier(_TextFieldModifier())
                            .foregroundColor(s.maintEnabled ? .white : .gray)
                            .disabled(!s.maintEnabled)
                            .keyboardType(.numberPad)

                            // maint miles
                            TextField("", text: Binding(
                                get: { String(s.maintMiles) },
                                set: { s.maintMiles = Int($0) ?? 0 }
                            ))
                            .modifier(_TextFieldModifier())
                            .foregroundColor(s.maintEnabled ? Color.primary : .gray)
                            .disabled(!s.maintEnabled)
                            .keyboardType(.numberPad)
                        } .frame(maxWidth: .infinity)
                    }
                }
            }
            
        } .navigationBarTitleDisplayMode(.inline)
    }
}

struct CarForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CarForm(car: .constant(Car()))
        }
    }
}
