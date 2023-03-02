//
//  IntroScreen.swift
//  Logbook
//
//  Created by bugs on 7/10/22.
//  Annimations are based on this sample video https://www.youtube.com/watch?v=0ytO3wCRKZU

import SwiftUI

struct IntroScreen: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Car.make, ascending: true)],
                  animation: .default
    ) private var cars: FetchedResults<Car>

    @State var isActive : Bool = false
    
    var body: some View {
        if isActive || cars.count > 0 {
            AppNavigation()
        } else {
            ScrollView {
                Spacer()
                TitleView()
                SummaryView()
                IntroContainerView()
                
                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    self.isActive = true
                }) {
                    Text("Continue")
                        .customButton()
                } .padding()
            }
        }
    }
}

struct IntroScreen_Previews: PreviewProvider {
    static var previews: some View {
        IntroScreen()
    }
}
