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
    f.zeroSymbol = ""
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

// custom modifier
struct _TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(3)
            .multilineTextAlignment(.trailing)
            .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.primary, style: StrokeStyle(lineWidth: 0.1)))
            //.background(Color(0xF2F2F7, alpha: 0.3))
    }
}

func convertDate(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter.date(from: date) ?? Date()
}
