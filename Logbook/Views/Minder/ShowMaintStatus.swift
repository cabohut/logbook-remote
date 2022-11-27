//
//  ShowMaintReminder.swift
//  Logbook
//
//  Created by bugs on 7/25/22.
//

import SwiftUI

struct ShowMaintStatus: View {
    let showOverdue: Bool
    var car: Car
    var reminder: Reminder
    
    var body: some View {
        
        HStack{
            reminder.serviceType.img()
                .foregroundColor(.orange)
                .frame(width: 30, alignment: .center)
                .font(Font.system(size: 22, weight: .regular))

            VStack {
                Text(car.make)
                    .frame(width: 80, alignment: .leading)
                    .font(.headline)
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
                                .foregroundColor((reminder.dateStatus == .isDue) ? .red : .orange)
                        } else {
                            Text(Date(timeIntervalSince1970: reminder.dateDue).formatted(date: .abbreviated, time: .omitted))
                        }
                    } else {
                        Text ("date: n/a")
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
                                .foregroundColor((reminder.milesStatus == .isDue) ? .red : .orange)
                            Image(systemName: (reminder.milesStatus == .isDue) ? "exclamationmark.triangle.fill" : "clock")
                                .foregroundColor((reminder.milesStatus == .isDue) ? .red : .orange)
                        } else {
                            Text("\(reminder.milesDue)")
                        }
                    } else {
                        Text ("milage: n/a")
                            .font(.caption)
                            .italic()
                            .padding(.horizontal, (showOverdue) ? 24 : 0)
                            .foregroundColor(.gray)
                    }
                }
            } .font(.footnote)
                .padding(.leading, 2)
        }
    }
}

struct ShowMaintStatus_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyView()
                .environmentObject(LogbookModel())
        }
    }
}
