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
    var m: MaintStatus
    
    var body: some View {
        
        HStack{
            m.serviceType.img()
                .foregroundColor(.orange)
                .frame(width: 30, alignment: .center)
                .font(Font.system(size: 22, weight: .regular))

            VStack {
                Text(car.make)
                    .frame(width: 80, alignment: .leading)
                    .font(.headline)
                Text(m.serviceType.rawValue)
                    .frame(width: 80, alignment: .leading)
                    .foregroundColor(.gray)
                    .font(.caption)
            } .padding(.horizontal, 6)
            
            Spacer()
            
            VStack (alignment: .trailing) {
                HStack {
                    if m.dateStatus != .notScheduled {
                        if showOverdue {
                            Text("\(abs(m.daysUntilDue)) days")
                                .foregroundColor((m.dateStatus == .isDue) ? .red : .orange)
                            Image(systemName: (m.dateStatus == .isDue) ? "exclamationmark.triangle.fill" : "clock")
                                .foregroundColor((m.dateStatus == .isDue) ? .red : .orange)
                        } else {
                            Text(Date(timeIntervalSince1970: m.dateDue).formatted(date: .abbreviated, time: .omitted))
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
                    if m.milesStatus != .notScheduled {
                        if showOverdue {
                            Text("\(abs(m.milesUntilDue)) miles")
                                .foregroundColor((m.milesStatus == .isDue) ? .red : .orange)
                            Image(systemName: (m.milesStatus == .isDue) ? "exclamationmark.triangle.fill" : "clock")
                                .foregroundColor((m.milesStatus == .isDue) ? .red : .orange)
                        } else {
                            Text("\(m.milesDue)")
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
