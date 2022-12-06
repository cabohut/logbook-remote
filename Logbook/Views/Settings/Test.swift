//
//  Test.swift
//  Logbook
//
//  Created by bugs on 8/17/22.
//

import SwiftUI

// custom modifier 2
struct _TextFieldModifier2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(3)
            .multilineTextAlignment(.trailing)
            //.background(Color(0xF2F2F7, alpha: 0.3))
            .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.primary, style: StrokeStyle(lineWidth: 0.1)))
    }
}

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
            .modifier(_TextFieldModifier())
            .frame(width: 80)
            .keyboardType(.numberPad)

            TextField("value", value: $val, formatter: numFormatter)
                .padding(.horizontal, 6)
                .modifier(_TextFieldModifier2())
                
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
