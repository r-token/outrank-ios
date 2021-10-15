//
//  SettingsView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var favoriteTeams: FavoriteTeams
    @State private var widgetTeam = UserDefaults(suiteName: "group.com.ryantoken.teamrankings")?.string(forKey: "WidgetTeam") ?? "Air Force"
    
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
                    
                    Picker(selection: $widgetTeam, label:
                        HStack {
                            Image(systemName: "square.and.arrow.down.on.square.fill")
                            .font(.title)
                            .foregroundColor(.purple)
                        
                            Text("Widget Team")
                    }) {
                        ForEach(allTeams, id: \.self) { team in
                            Text(team)
                        }
                    }
                    .onChange(of: widgetTeam) { newWidgetTeam in
                          // Run code to save
                        UserDefaults(suiteName: "group.com.ryantoken.teamrankings")?.set(newWidgetTeam, forKey: "WidgetTeam")
                        
                        print("shared user defaults for widget team is now \(newWidgetTeam)")
                   }
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
