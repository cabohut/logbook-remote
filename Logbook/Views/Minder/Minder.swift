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
                        ForEach (_state.maintStatus) { ms in
                            if (ms.dateStatus == .isDue || ms.milesStatus == .isDue) {
                                ShowMaintStatus(showOverdue: true, car: appData.cars[ms.carIdx], mStatus: ms)
                            }
                        }
                    }
                    
                    Section (header: Text("Upcoming(\(_state.upcomingCount))").bold()) {
                        ForEach (_state.maintStatus) { ms in
                            if (ms.dateStatus == .isUpcoming && ms.milesStatus == .isUpcoming) {
                                ShowMaintStatus(showOverdue: false, car: appData.cars[ms.carIdx], mStatus: ms)
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
