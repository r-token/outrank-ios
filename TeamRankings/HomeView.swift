//
//  ContentView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct HomeView: View {
    @State private var currentTeam = UserDefaults.standard.string(forKey: "CurrentTeam") ?? "Air Force"
    @State private var favoriteTeam = UserDefaults.standard.string(forKey: "FavoriteTeam")
    @State private var teamRankings = [String:String]()
    @State private var isShowingTeamPickerView = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(teamRankings.sorted(by: >), id: \.key) { stat, ranking in
                        Section(header: Text(stat)) {
                            Text(ranking)
                        }
                    }
                }
            }
            
            .navigationTitle(currentTeam)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingTeamPickerView = true
                    }) {
                        Text("Choose Team")
                    }
                }
            }
        }
        
        .sheet(isPresented: $isShowingTeamPickerView, onDismiss: handleTeamPickerDismiss) {
            TeamPickerView(currentTeam: $currentTeam)
        }
        
        .task {
            print("getting new data")
            do {
                let teamRankings = try await TeamFetcher.getTeamRankingsFor(team: currentTeam)
                self.teamRankings = try teamRankings.allProperties()
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func handleTeamPickerDismiss() {
        print("Handle some dismissal stuff here")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
