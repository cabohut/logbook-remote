//
//  LogRow.swift
//  Logbook
//
//  Created by sam on 2/27/22.
//

import SwiftUI

struct LogRow: View {
    let rec: Log
    
    var body: some View {
        HStack {
            Text("Test LogRow Value")
            /*
            rec.type.img()
                .foregroundColor(.orange)
                .frame(width: 30, alignment: .center)
                .font(Font.system(size: 22, weight: .regular))

            VStack {
                Text(rec.date.formatted(date: .abbreviated, time: .omitted))
                    .frame(width: 140, alignment: .leading)
                let details_txt = rec.details.isEmpty ? rec.type.rawValue.capitalized : rec.type.rawValue.capitalized + ", " + rec.details
                Text(details_txt)
                    .frame(width: 140, alignment: .leading)
                    .foregroundColor(.gray)
                    .font(.caption)
            } .padding(.horizontal, 6)
            Spacer()
            VStack (alignment: .trailing) {
                Text("\(rec.odometer)")
                    .font(.system(.body, design: .monospaced))
                Text("miles")
                    .foregroundColor(.gray)
                    .font(.caption)
            }.padding(.trailing, 5)
             */
        }
    }
}

struct LogRow_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            LogRow(rec: Log())
        } .previewLayout(.fixed(width: 300, height: 70))
    }
}
