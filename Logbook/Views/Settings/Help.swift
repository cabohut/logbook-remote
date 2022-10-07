//
//  Help.swift
//  Logbook
//
//  Created by bugs on 9/19/22.
//

import SwiftUI

struct Help: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            Spacer()
            TitleView()
            SummaryView()
            IntroContainerView()
            Spacer(minLength: 30)
            
            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                dismiss()
            }) {
                Text("Continue")
                    .customButton()
            } .padding()
        }
    }
}

struct Help_Previews: PreviewProvider {
    static var previews: some View {
        Help()
    }
}
