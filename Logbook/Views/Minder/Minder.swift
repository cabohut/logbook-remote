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
                        ForEach (_state.maintStatus) { m in
                            if (m.dateStatus == .isDue || m.milesStatus == .isDue) {
                                ShowMaintStatus(showOverdue: true, car: appData.cars[m.carIdx], m: m)
                            }
                        }
                    }
                    
                    Section (header: Text("Upcoming(\(_state.upcomingCount))").bold()) {
                        ForEach (_state.maintStatus) { m in
                            if (m.dateStatus == .isUpcoming && m.milesStatus == .isUpcoming) {
                                ShowMaintStatus(showOverdue: false, car: appData.cars[m.carIdx], m: m)
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
