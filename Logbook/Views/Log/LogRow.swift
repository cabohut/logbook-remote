//
//  LogRow.swift
//  Logbook
//
//  Created by sam on 2/27/22.
//

import SwiftUI

struct LogRow: View {
    let log: Log
    
    var body: some View {
        HStack {
            log.serviceTypeE.img()
                .foregroundColor(.orange)
                .frame(width: 30, alignment: .center)
                .font(Font.system(size: 22, weight: .regular))
            
            VStack {
                Text(log.date_.formatted(date: .abbreviated, time: .omitted))
                    .frame(width: 140, alignment: .leading)
                let details_txt = log.details_.isEmpty ? log.serviceType_.capitalized : log.serviceType_.capitalized + ", " + log.details_
                Text(details_txt)
                    .frame(width: 140, alignment: .leading)
                    .foregroundColor(.gray)
                    .font(.caption)
            } .padding(.horizontal, 6)
            
            Spacer()
            
            VStack (alignment: .trailing) {
                Text("\(log.odometer)")
                    .font(.system(.body, design: .monospaced))
                Text("miles")
                    .foregroundColor(.gray)
                    .font(.caption)
            }.padding(.trailing, 5)
        }
    }
}

struct LogRow_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            LogRow(log: Log())
        } .previewLayout(.fixed(width: 300, height: 70))
    }
}
