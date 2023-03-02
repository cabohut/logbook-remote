//
//  CarRow.swift
//  Logbook
//
//  Created by bugs on 5/20/22.
//

import SwiftUI

struct CarRow: View {
    @StateObject var car: Car

    var body: some View {
        VStack (alignment: .leading) {
            Text("\(car.year_)")
                .foregroundColor(.orange)
            HStack {
                Text("\(car.make_)")
                Text("\(car.model_)")
            } .font(.title2)
        }
    }
}

struct CarRow_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            CarRow(car: Car())
        } .previewLayout(.fixed(width: 300, height: 70))
    }
}
