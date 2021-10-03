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
    @State private var teamRankings = [String:Int]()
    @State private var sortMethod = SortMethods.byStatAlphabetically
    
    @State private var isShowingTeamPickerView = false
    @State private var isShowingSortActionSheet = false
    
    enum SortMethods {
        case byStatAlphabetically
        case byStatReverseAlphabetically
        case byRankingAscending
        case byRankingDescending
    }
    
    var sortedDictionary: [Dictionary<String, Int>.Element]{
        switch sortMethod {
        case SortMethods.byStatAlphabetically:
            return teamRankings.sorted{ $0.key < $1.key }
        case SortMethods.byStatReverseAlphabetically:
            return teamRankings.sorted{ $0.key > $1.key }
        case SortMethods.byRankingAscending:
            return teamRankings.sorted{ $0.value < $1.value }
        case SortMethods.byRankingDescending:
            return teamRankings.sorted{ $0.value > $1.value }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(sortedDictionary, id: \.self.key) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(getHumanReadableStat(for: item.key))
                                .font(.headline)
                            Text(getHumanReadableRanking(for: item.value))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .refreshable {
                    await refreshRankings()
                }
            }
            
            .navigationTitle(currentTeam)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingSortActionSheet = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingTeamPickerView = true
                    }) {
                        Text("Choose Team")
                    }
                }
            }
        }
        
        .sheet(isPresented: $isShowingTeamPickerView) {
            TeamPickerView(currentTeam: $currentTeam, teamRankings: $teamRankings)
        }
        
        .actionSheet(isPresented: $isShowingSortActionSheet) {
            ActionSheet(title: Text("Sort Results"), message: Text("Choose a method for sorting the results"), buttons: [
                    .default(Text("Sort by stat alphabetically")) {
                        sortByStatAlphabetically()
                    },
                    .default(Text("Sort by stat reverse alphabetically")) {
                        sortByStatReverseAlphabetically()
                    },
                    .default(Text("Sort by ranking ascending")) {
                        sortByRankingAscending()
                    },
                    .default(Text("Sort by ranking descending")) {
                        sortByRankingDescending()
                    },
                    .cancel()
                ]
            )
        }
        
        .task {
            if teamRankings.isEmpty {
                print("fetching new data")
                do {
                    let fetchedRankings = try await TeamFetcher.getTeamRankingsFor(team: currentTeam)
                    teamRankings = try fetchedRankings.allProperties()
                } catch {
                    print("Request failed with error: \(error)")
                }
            } else {
                print("We already have data, not fetching onAppear")
            }
        }
    }
    
    func getHumanReadableStat(for stat: String) -> String {
        if stat != "DefensiveTDs" {
            let cleanStat = stat.camelCaseToWords()
            return cleanStat
        } else {
            return "Defensive TDs"
        }
    }
    
    func getHumanReadableRanking(for ranking: Int) -> String {
        if ranking == 11 || ranking == 12 || ranking == 13 || ranking == 111 || ranking == 112 || ranking == 113 {
            return "\(ranking)th"
        } else if ranking % 10 == 1 {
            return "\(ranking)st"
        } else if ranking % 10 == 2 {
            return "\(ranking)nd"
        } else if ranking % 10 == 3 {
            return "\(ranking)rd"
        } else if ranking == 99999 {
            return "Unknown"
        } else {
            return "\(ranking)th"
        }
    }
    
    func sortByStatAlphabetically() {
        sortMethod = SortMethods.byStatAlphabetically
    }
    
    func sortByStatReverseAlphabetically() {
        sortMethod = SortMethods.byStatReverseAlphabetically
    }
    
    func sortByRankingAscending() {
        sortMethod = SortMethods.byRankingAscending
    }
    
    func sortByRankingDescending() {
        sortMethod = SortMethods.byRankingDescending
    }
    
    func refreshRankings() async {
        Task {
            print("fetching new data")
            do {
                let fetchedRankings = try await TeamFetcher.getTeamRankingsFor(team: currentTeam)
                teamRankings = try fetchedRankings.allProperties()

            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
