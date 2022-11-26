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
    var mStatus: MaintStatus
    
    var body: some View {
        
        HStack{
            mStatus.serviceType.img()
                .foregroundColor(.orange)
                .frame(width: 30, alignment: .center)
                .font(Font.system(size: 22, weight: .regular))

            VStack {
                Text(car.make)
                    .frame(width: 80, alignment: .leading)
                    .font(.headline)
                Text(mStatus.serviceType.rawValue)
                    .frame(width: 80, alignment: .leading)
                    .foregroundColor(.gray)
                    .font(.caption)
            } .padding(.horizontal, 6)
            
            Spacer()
            
            VStack (alignment: .trailing) {
                HStack {
                    if mStatus.dateStatus != .notScheduled {
                        if showOverdue {
                            Text("\(abs(mStatus.daysUntilDue)) days")
                                .foregroundColor((mStatus.dateStatus == .isDue) ? .red : .orange)
                            Image(systemName: (mStatus.dateStatus == .isDue) ? "exclamationmark.triangle.fill" : "clock")
                                .foregroundColor((mStatus.dateStatus == .isDue) ? .red : .orange)
                        } else {
                            Text(Date(timeIntervalSince1970: mStatus.dateDue).formatted(date: .abbreviated, time: .omitted))
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
                    if mStatus.milesStatus != .notScheduled {
                        if showOverdue {
                            Text("\(abs(mStatus.milesUntilDue)) miles")
                                .foregroundColor((mStatus.milesStatus == .isDue) ? .red : .orange)
                            Image(systemName: (mStatus.milesStatus == .isDue) ? "exclamationmark.triangle.fill" : "clock")
                                .foregroundColor((mStatus.milesStatus == .isDue) ? .red : .orange)
                        } else {
                            Text("\(mStatus.milesDue)")
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
