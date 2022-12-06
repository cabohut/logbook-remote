//
//  AppHelpers.swift
//  Logbook
//
//  Created by bugs on 7/19/22.
//

import Foundation
import SwiftUI

let numFormatter: NumberFormatter = {
    let f = NumberFormatter()
    //f.zeroSymbol = ""
    f.numberStyle = .decimal
    return f
} ()

let currencyFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .currency
    return f
} ()

extension Color {
    // https://bit.ly/3cUKorw
    init(_ hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

func convertDate(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter.date(from: date) ?? Date()
}
