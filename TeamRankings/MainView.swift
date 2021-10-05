//
//  TabView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var favoriteTeams = FavoriteTeams()
    
    var body: some View {
        TabView {
            RankingsView()
                .tabItem {
                    Label("Rankings", systemImage: "list.bullet.rectangle.portrait")
                }
            
            ComparisonView()
                .tabItem {
                    Label("Compare", systemImage: "eyeglasses")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(favoriteTeams)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
