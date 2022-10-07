//
//  CarRow.swift
//  Logbook
//
//  Created by bugs on 5/20/22.
//

import SwiftUI

struct CarRow: View {
    let rec: Car
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("\(rec.year)")
                .foregroundColor(.orange)
            HStack {
                Text("\(rec.make)")
                Text("\(rec.model)")
            } .font(.title2)
        }
    }
}

struct CarRow_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            CarRow(rec: Car())
        } .previewLayout(.fixed(width: 300, height: 70))
    }
}
