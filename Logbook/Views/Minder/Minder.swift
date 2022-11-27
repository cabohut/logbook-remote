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
                    Section (header: Text("Overdue (\(_state.overdueCount))").bold()) {
                        ForEach (_state.reminders) { r in
                            if (r.dateStatus == .isDue || r.milesStatus == .isDue) {
                                ShowMaintStatus(showOverdue: true, car: appData.cars[r.carIdx], reminder: r)
                            }
                        }
                    }
                    
                    Section (header: Text("Upcoming(\(_state.upcomingCount))").bold()) {
                        ForEach (_state.reminders) { r in
                            if (r.dateStatus == .isUpcoming && r.milesStatus == .isUpcoming) {
                                ShowMaintStatus(showOverdue: false, car: appData.cars[r.carIdx], reminder: r)
                            }
                        }
                    }
                } .navigationTitle("Service Reminders")
            }
        }
    }
}

struct Minder_Previews: PreviewProvider {
    static var previews: some View {
        Minder()
            .environmentObject(LogbookModel())
            .environmentObject(AppState())
    }
}
