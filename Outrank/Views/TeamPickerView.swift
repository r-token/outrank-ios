//
//  TeamPickerView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct TeamPickerView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss
    @Environment(TabController.self) private var tabController

    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    var favorites: FetchedResults<Favorite>
    
    @Binding var team: String
    @Binding var teamRankings: [String:Int]
    
    let type: TeamPickerTypes
    let allTeams = AllTeams().getTeams()
    
    enum TeamPickerTypes {
        case rankings
        case comparisonTeamOne
        case comparisonTeamTwo
    }
    
    private var userDefaultsKey: String {
        switch type {
        case TeamPickerTypes.rankings:
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
                        ForEach(favorites) { favorite in
                            Button(action: {
                                chooseTeam(team: favorite.wrappedTeam)
                                dismiss()
                            }) {
                                Text(favorite.wrappedTeam)
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
                                    Text(team)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                
                .navigationTitle("Choose Team")
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Done")
                                .bold()
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
                HapticGenerator.playSuccessHaptic()
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func removeFromFavorites(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request'
            let favorite = favorites[offset]
            
            // delete it from the context
            moc.delete(favorite)
        }
        
        // save the new context
        try? moc.save()
    }
}
