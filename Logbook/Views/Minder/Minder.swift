//
//  Minder.swift
//  Logbook
//
//  Created by sam on 2/26/22.
//

import SwiftUI


struct Minder: View {

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Car.make, ascending: true)],
                  animation: .default
    ) private var cars: FetchedResults<Car>

    var body: some View {
        if (cars.count == 0) {
            Text("You have not added any cars in your Logbook")
                .foregroundColor(.gray)
                .font(.subheadline)
                .navigationTitle("Service Reminders")
        } else {
            VStack {
                List {
                    ForEach (cars) { c in
                        Section (header: Text(c.make_ + " " + c.model_).bold()) {
                            Text("Reminders go here")
                            ForEach (c.remindersA) { r in
                                Text(r.serviceType_)
                                /*********
                                if (r.dateStatus == .isDue || r.milesStatus == .isDue) {
                                    ShowReminder(showOverdue: true, reminder: r)
                                }
                                if (r.dateStatus == .isUpcoming && r.milesStatus == .isUpcoming) {
                                    ShowReminder(showOverdue: false, reminder: r)
                                }
                                 */
                            }
                        }
                    } // ForEach
                } .navigationTitle("Service Reminders")
            } // VStack
        } // else
    }
}

struct Minder_Previews: PreviewProvider {
    static var previews: some View {
        Minder()
    }
}
