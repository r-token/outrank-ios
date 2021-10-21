//
//  SettingsView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI
import WidgetKit
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var favoriteTeams: FavoriteTeams
    @StateObject var store: Store = Store()
    
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
                            Image(systemName: "square.text.square.fill")
                            .font(.title)
                            .foregroundColor(.purple)
                        
                            Text("Widget")
                    }) {
                        ForEach(allTeams, id: \.self) { team in
                            Text(team)
                        }
                    }
                    .onChange(of: widgetTeam) { newWidgetTeam in
                          // Save widget team to App Group userdefaults
                        UserDefaults(suiteName: "group.com.ryantoken.teamrankings")?.set(newWidgetTeam, forKey: "WidgetTeam")
                        WidgetCenter.shared.reloadAllTimelines()
                        
                        print("shared user defaults for widget team is now \(newWidgetTeam)")
                   }
                }
                
                Section {
                    Button(action: {
                        SKStoreReviewController.requestReviewInCurrentScene()
                    }) {
                        HStack {
                            Image(systemName: "heart.square.fill")
                                .font(.title)
                                .foregroundColor(.red)
                            Text("Rate")
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(Font.footnote.weight(.bold))
                                .foregroundColor(.lightGray)
                        }
                    }
                    
                    NavigationLink(destination: TipJarView()) {
                        HStack {
                            Image(systemName: "centsign.square.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text("Leave a Tip")
                        }
                    }
                    
                    NavigationLink(destination: SubscriptionsView()) {
                        HStack {
                            Image(systemName: "dollarsign.square.fill")
                                .font(.title)
                                .foregroundColor(.green)
                            Text("Subscribe")
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
        .environmentObject(store)
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
