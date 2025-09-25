//
//  TabView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct MainView: View {
    @State private var tabController = TabController()
    
    var body: some View {
        TabView(selection: $tabController.activeTab) {
            RankingsView()
                .tag(Tab.rankings)
                .tabItem {
                    Label("Rankings", systemImage: "list.bullet.rectangle.portrait")
                }

            ComparisonView()
                .tag(Tab.compare)
                .tabItem {
                    Label("Compare", systemImage: "eyeglasses")
                }

            SettingsView()
                .tag(Tab.settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environment(tabController)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
