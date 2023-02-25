//
//  ShowReminder.swift
//  Logbook
//
//  Created by bugs on 11/27/22.
//

import Foundation

//
//  ShowMaintReminder.swift
//  Logbook
//
//  Created by bugs on 7/25/22.
//

import SwiftUI

struct ShowReminder: View {
    let showOverdue: Bool
    // var reminder: Reminder99

    var body: some View {
        
        HStack{
            Text("Reminders go here")
            /*
            reminder.serviceType.img()
                .foregroundColor(.orange)
                .frame(width: 30, alignment: .center)
                .font(Font.system(size: 22, weight: .regular))

            VStack {
                Text(reminder.serviceType.rawValue)
                    .frame(width: 80, alignment: .leading)
                    .foregroundColor(.gray)
                    .font(.caption)
            } .padding(.horizontal, 6)
            
            Spacer()
            
            VStack (alignment: .trailing) {
                HStack {
                    if reminder.dateStatus != .notScheduled {
                        if showOverdue {
                            Text("\(abs(reminder.daysUntilDue)) days")
                                .foregroundColor((reminder.dateStatus == .isDue) ? .red : .orange)
                            Image(systemName: (reminder.dateStatus == .isDue) ? "exclamationmark.triangle.fill" : "clock")
                                .foregroundColor((reminder.dateStatus == .isDue) ? .red : .green)
                        } else {
                            Text(Date(timeIntervalSince1970: reminder.dateDue).formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.green)
                        }
                    } else {
                        Text ("-----")
                            .font(.caption)
                            .italic()
                            .padding(.horizontal, (showOverdue) ? 24 : 0)
                            .foregroundColor(.gray)
                    }
                }
                
                HStack {
                    if reminder.milesStatus != .notScheduled {
                        if showOverdue {
                            Text("\(abs(reminder.milesUntilDue)) miles")
                                .foregroundColor((reminder.milesStatus == .isDue) ? .red : .green)
                            Image(systemName: (reminder.milesStatus == .isDue) ? "exclamationmark.triangle.fill" : "clock")
                                .foregroundColor((reminder.milesStatus == .isDue) ? .red : .green)
                        } else {
                            Text("\(reminder.milesDue)")
                                .foregroundColor(.green)
                        }
                    } else {
                        Text ("-----")
                            .font(.caption)
                            .italic()
                            .padding(.horizontal, (showOverdue) ? 24 : 0)
                            .foregroundColor(.gray)
                    }
                }
            } .font(.footnote)
                .padding(.leading, 2)
            */
        }
    }
}

struct ShowReminder_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyView()
                .environmentObject(LogbookModel())
        }
    }
}
