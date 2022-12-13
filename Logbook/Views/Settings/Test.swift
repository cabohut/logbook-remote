//
//  Test.swift
//  Logbook
//
//  Created by bugs on 8/17/22.
//

import SwiftUI

struct Test: View {    
    @State private var dateFilter = 0
    @State private var val = 0
    @State private var str = ""

    var body: some View {
        VStack {
            Section {
                VStack {
                    Text("Track overdue and upcoming services based on each car's maintenance schedule.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                } .padding([.leading, .trailing], 5)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .opacity(0.5)
                    .padding(.top, 10)
            }
            
            TextField("number", text: Binding(
                get: { String(val) },
                set: { val = Int($0) ?? 0 }
            ))
            .padding(.horizontal, 6)
            .frame(width: 80)
            .keyboardType(.numberPad)

            TextField("value", value: $val, formatter: numFormatter)
                .padding(.horizontal, 6)
                
                .frame(width: 80)
                .keyboardType(.numberPad)
            
            TextField("value", value: $str, formatter: NumberFormatter())
                .padding(.trailing, 10)
                .frame(width: 80)
                .keyboardType(.numberPad)
            
            List {
                Section (header: Text("Test").bold()) {
                    
                    ForEach (0..<3) { m in
                        Text(String(m))
                    }
                }
                
            } .navigationTitle("Test")
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
