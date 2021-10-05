//
//  MultiPickerView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

import SwiftUI

struct MultiPickerView<Selectable: Identifiable & Hashable>: View {
    @EnvironmentObject var favoriteTeams: FavoriteTeams
    
    let allTeams: [Selectable]
    let teamToString: (Selectable) -> String

    var selectedCount: Int
    
    var favorites: [String] {
        return Array(favoriteTeams.getFavorites()).sorted()
    }

    var body: some View {
        List {
            Section(header: Text("Favorite Teams")) {
                ForEach(favorites) { team in
                    Button(action: { toggleSelection(team: team) }) {
                        FavoriteTeamsSelectionView(team: team)
                            .font(.headline)
                    }
                }
                
                if favorites.isEmpty {
                    Text("No favorites yet ☹️")
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("All Teams")) {
                ForEach(allTeams) { team in
                    let team = teamToString(team)
                    
                    Button(action: { toggleSelection(team: team) }) {
                        FavoriteTeamsSelectionView(team: team)
                    }
                }
            }
        }
        .animation(.default, value: favorites)
        
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleSelection(team: String) {
        if favoriteTeams.contains(team) {
            favoriteTeams.remove(team)
        } else {
            favoriteTeams.add(team)
        }
    }
}

struct MultiPickerView_Previews: PreviewProvider {
    struct IdentifiableString: Identifiable, Hashable {
        let string: String
        var id: String { string }
    }

    @State static var selected: Set<IdentifiableString> = Set(["A", "C"].map { IdentifiableString(string: $0) })
    
    static let favoriteTeams = FavoriteTeams()

    static var previews: some View {
        NavigationView {
            MultiPickerView(
                allTeams: ["A", "B", "C", "D"].map { IdentifiableString(string: $0) },
                teamToString: { $0.string },
                selectedCount: 4
            )
        }
        .environmentObject(favoriteTeams)
    }
}
