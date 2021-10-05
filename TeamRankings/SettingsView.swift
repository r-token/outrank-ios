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
                MultiPicker(
                    label: Text("Favorite Teams:"),
                    allTeams: allTeams,
                    teamToString: { $0 },
                    selectedCount: selectedCount
                )
            }
            
            .navigationTitle("Settings")
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
