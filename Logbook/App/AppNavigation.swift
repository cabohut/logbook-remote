//
//  AppNavigation.swift
//  Logbook
//
//  Created by sam on 2/28/22.
//

import SwiftUI
import os.log

struct AppNavigation: View {
    var body: some View {
        TabView() {
            // MARK: - CarsList
            NavigationView {
                CarsList() {
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
