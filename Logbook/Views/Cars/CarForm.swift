//
//  CarForm.swift
//  Logbook
//
//  Created by bugs on 5/20/22.
//

import SwiftUI

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
    @Binding var rec: Car
    
    @Environment(\.isPresented) var isPresented
    @EnvironmentObject var appData : LogbookModel
    @EnvironmentObject var _state : AppState
    
    @State private var maintenanceMode = 0
    @State var maintMode = true
    
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
                
                ForEach ($rec.services) { $s in
                    if (s.serviceType != .odometer && s.serviceType != .gas) {
                        HStack {
                            Toggle(isOn: $s.maintEnabled, label: {Text(s.serviceType.rawValue.capitalized)})
                                .toggleStyle(CheckboxStyle())
                            Spacer()
                            
                            TextField("", value: $s.maintMonths, formatter: NumberFormatter())
                                .padding(.horizontal, 5)
                                .modifier(_TextFieldModifier())
                                .frame(width: 60)
                                .keyboardType(.numberPad)
                            TextField("", value: $s.maintMiles, formatter: numFormatter)
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
                Reminder.updateRemindersArray(cars: appData.cars, state: _state)
                print("value changed")
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
