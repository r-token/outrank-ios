//
//  TrendsView.swift
//  Outrank
//
//  Created by Ryan Token on 11/7/21.
//

import SwiftUI

struct TrendsView: View {
    @State private var selectedTeam = "Texas A&M"
    @State private var selectedStat = "RedZoneOffense"
    @State private var rankingTrends = []
    @State private var apiError = false
    
    let allTeams = AllTeams().getTeams()
    let allStats = AllStats().getStats()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Picker("Choose a Team", selection: $selectedTeam) {
                            ForEach(allTeams) { team in
                                Text(team)
                            }
                        }
                        
                        Picker("Choose a Stat", selection: $selectedStat) {
                            ForEach(allStats) { stat in
                                Text(Conversions.getHumanReadableStat(for: stat))
                            }
                        }
                    }
                }
            }
            
            .navigationTitle("Trends")
        }
        
        .task {
            if rankingTrends.isEmpty {
                await refreshRankings()
            } else {
                print("We already have trend data, not fetching onAppear")
            }
        }
    }
    
    func refreshRankings() async {
        Task {
            print("fetching new trend data")
            do {
                let fetchedRankings = try await HistoricalFetcher.getHistoricalRankingsFor(team: selectedTeam, isoDate: "2021-10-30T14:00:00.000Z")
                let rankingsByDate = fetchedRankings.sorted { $0.date < $1.date }
                rankingTrends = rankingsByDate
                apiError = false
                
                print(rankingTrends)
            } catch {
                print("Request failed with error: \(error)")
                apiError = true
            }
        }
    }
}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
