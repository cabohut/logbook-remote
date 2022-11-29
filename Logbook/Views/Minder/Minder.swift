//
//  Minder.swift
//  Logbook
//
//  Created by sam on 2/26/22.
//

import SwiftUI

struct Minder: View {
    @EnvironmentObject var appData : LogbookModel
    @EnvironmentObject var _state : AppState
    
    var body: some View {
        if (appData.cars.count == 0) {
            Text("You have not added any cars in your Logbook")
                .foregroundColor(.gray)
                .font(.subheadline)
                .navigationTitle("Service Reminders")
        } else {
            VStack {
                List {
                    ForEach (appData.cars) { c in
                        Section (header: Text(c.make + " " + c.model).bold()) {
                            ForEach (c.reminders) { r in
                                if (r.dateStatus == .isDue || r.milesStatus == .isDue) {
                                    ShowReminder(showOverdue: true, reminder: r)
                                }
                                if (r.dateStatus == .isUpcoming && r.milesStatus == .isUpcoming) {
                                    ShowReminder(showOverdue: false, reminder: r)
                                }
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
            .environmentObject(LogbookModel())
            .environmentObject(AppState())
    }
}
