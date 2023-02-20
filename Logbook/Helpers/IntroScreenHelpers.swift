//
//  IntroScreenHelpers.swift
//
//
//  Created by bugs on 7/15/22.
//  Mostly based on this blog https://betterprogramming.pub/creating-an-apple-like-splash-screen-in-swiftui-fdeb36b47e81

import SwiftUI

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

extension Text {
    func customTitleText() -> Text {
        self
            .fontWeight(.black)
            .font(.system(size: 32))
    }
}

struct TitleView: View {
    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View {
        VStack {
            Image(systemName: "car.2.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
                .padding()
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.00
                    }
                }
        }
        VStack {
            Text("Welcome to")
                .customTitleText()

            Text("Car Logbook")
                .customTitleText()
                .foregroundColor(.orange)
        }
    }
}

struct SummaryView: View {
    var body: some View {
        VStack {
            Text("Track service records and maintenance reminders to avoid costly repairs.")
                .foregroundColor(.secondary)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct IntroContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            IntroDetailView(title: "Cars", subTitle: "Add details about your cars and the recommended maintenance schedule.", imageName: "car")

            IntroDetailView(title: "Logs", subTitle: "Log your maintenance services, gas fillup, and current odometer.", imageName: "text.book.closed")

            IntroDetailView(title: "Minder", subTitle: "Track your upcoming or overdue maintenance reminders.", imageName: "alarm")
            Text("Maintenance reminders are calculated based on the last service date or milage. Make sure you keep milage current by loggin gas fillup or the odometer reading.")
                .foregroundColor(.secondary)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding(.horizontal)
    }
}

struct IntroDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.title)
                .frame(width: 30, alignment: .center)
                .foregroundColor(.orange)
                .padding()
                .accessibility(hidden: true)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)

                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}

