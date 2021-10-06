//
//  TeamPickerView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct TeamPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var favoriteTeams: FavoriteTeams
    @EnvironmentObject private var tabController: TabController
    
    @Binding var team: String
    @Binding var teamRankings: [String:Int]
    
    let type: TeamPickerTypes
    let allTeams = AllTeams().getTeams()
    
    var favorites: [String] {
        return Array(favoriteTeams.getFavorites()).sorted()
    }
    
    enum TeamPickerTypes {
        case home
        case comparisonTeamOne
        case comparisonTeamTwo
    }
    
    private var userDefaultsKey: String {
        switch type {
        case TeamPickerTypes.home:
            return "CurrentTeam"
        case TeamPickerTypes.comparisonTeamOne:
            return "TeamOne"
        case TeamPickerTypes.comparisonTeamTwo:
            return "TeamTwo"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Favorite Teams")) {
                        ForEach(favorites) { team in
                            Button(action: {
                                chooseTeam(team: team)
                                dismiss()
                            }) {
                                Text(team)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                        }
                        .onDelete(perform: removeFromFavorites)
                        
                        if favorites.isEmpty {
                            Button(action: {
                                dismiss()
                                tabController.open(.settings)
                            }) {
                                HStack(spacing: 6) {
                                    Text("Choose favorites in")
                                    HStack(spacing: 1) {
                                        Image(systemName: "gear")
                                        Text("Settings")
                                    }
                                }
                                .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Section(header: Text("All Teams")) {
                        ForEach(allTeams, id: \.self) { team in
                            HStack {
                                Button(action: {
                                    chooseTeam(team: team)
                                    dismiss()
                                }) {
                                    favoriteTeams.contains(team) ?
                                        Text(team)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    :
                                        Text(team)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                .animation(.default, value: favorites)
                
                .navigationTitle("Choose Team")
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    func chooseTeam(team: String) {
        Task {
            print("fetching new data")
            do {
                let fetchedRankings = try await TeamFetcher.getTeamRankingsFor(team: team)
                teamRankings = try fetchedRankings.allProperties()
                
                UserDefaults.standard.set(team, forKey: userDefaultsKey)
                self.team = team
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func removeFromFavorites(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        favoriteTeams.remove(favorites[index])
    }
}
