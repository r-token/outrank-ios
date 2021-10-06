//
//  SettingsView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var favoriteTeams: FavoriteTeams
    
    let allTeams = AllTeams().getTeams()
    
    var selectedCount: Int {
        return favoriteTeams.getFavorites().count
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    MultiPicker(
                        label: FavoriteTeamsLabel(),
                        allTeams: allTeams,
                        teamToString: { $0 },
                        selectedCount: selectedCount
                    )
                }
                
                Section {
                    NavigationLink(destination: TipJarView()) {
                        HStack {
                            Image(systemName: "dollarsign.square.fill")
                                .font(.title)
                                .foregroundColor(.green)
                            Text("Tip Jar")
                        }
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        Image(systemName: "bell.square.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                        Text("About")
                    }
                }
            }
            
            .navigationTitle("Settings")
        }
    }
}

struct FavoriteTeamsLabel: View {
    var body: some View {
        HStack {
            Image(systemName: "star.square.fill")
                .font(.title)
                .foregroundColor(.yellow)
            Text("Favorites")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let favoriteTeams = FavoriteTeams()
    
    static var previews: some View {
        SettingsView()
            .environmentObject(favoriteTeams)
    }
}
