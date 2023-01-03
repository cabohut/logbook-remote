//
//  AppNavigation.swift
//  Logbook
//
//  Created by sam on 2/28/22.
//

import SwiftUI

struct AppNavigation: View {
    @EnvironmentObject var appData : LogbookModel

    @State private var err: ErrorWrapper?
    
    var body: some View {
        TabView() {
            // MARK: - CarsList
            NavigationView {
                CarsList() {
                    Task {   // saveAction()
                        do {
                            try await Car.saveData(cars: appData.cars)
                        } catch {
                            err = ErrorWrapper(error: Error.self as! Error, guidance: "Error saving file, try again later.")
                        }
                    }
                }
            } .navigationViewStyle(.stack)
                .tabItem {
                    Label ("Cars", systemImage: "car.2.fill")
                }

            // MARK: - LogbookHistory
            NavigationView {
                LogbookHistory() {
                }
            } .navigationViewStyle(.stack)
                .tabItem {
                    Label ("Logbook", systemImage: "text.book.closed")
                }

            // MARK: - Minder
            NavigationView {
                Minder()
            } .navigationViewStyle(.stack)
                .tabItem {
                    Label ("Minder", systemImage: "alarm")
                } .badge(_g.shared.overdueCount)

            // MARK: - Settings
            NavigationView {
                Settings()
            } .navigationViewStyle(.stack)
                .tabItem {
                    Label ("Settings", systemImage: "gear")
                }
        } .accentColor(.orange)
            .onAppear() {
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = .systemBackground
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
    }
}

struct AppNavigation_Preview: PreviewProvider {
    static var previews: some View {
        AppNavigation()
            .environmentObject(LogbookModel())
    }
}
