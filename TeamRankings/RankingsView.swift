//
//  ContentView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct RankingsView: View {
    @State private var currentTeam = UserDefaults.standard.string(forKey: "CurrentTeam") ?? "Air Force"
    @State private var teamRankings = [String:Int]()
    @State private var sortMethod = SortMethods.byStatAlphabetically
    @State private var randomId = UUID()
    
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
    
    var currentSortMethod: String {
        switch sortMethod {
        case SortMethods.byStatAlphabetically:
            return "stat alphabetically"
        case SortMethods.byStatReverseAlphabetically:
            return "stat reverse alphabetically"
        case SortMethods.byRankingAscending:
            return "ranking ascending"
        case SortMethods.byRankingDescending:
            return "ranking descending"
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Sorted by \(currentSortMethod)")) {
                    ForEach(sortedDictionary, id: \.self.key) { item in
                        NavigationLink(destination: RankingDetailView(team: currentTeam, stat: item.key, humanReadableStat: getHumanReadableStat(for: item.key), ranking: getHumanReadableRanking(for: item.value))) {
                            HStack(alignment: .center, spacing: 8) {
                                Text(getHumanReadableStat(for: item.key))
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text(getHumanReadableRanking(for: item.value))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .refreshable {
                await refreshRankings()
            }
            .animation(.default, value: teamRankings)
            .animation(.default, value: sortMethod)
            
            .navigationTitle(currentTeam)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingTeamPickerView.toggle()
                    }) {
                        Text("Choose Team")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSortActionSheet.toggle()
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .id(randomId)
            
            .sheet(isPresented: $isShowingTeamPickerView) {
                TeamPickerView(team: $currentTeam, teamRankings: $teamRankings, type: TeamPickerView.TeamPickerTypes.home)
                    .onDisappear {
                        randomId = UUID() // this solves the SwiftUI bug that causes sheets in toolbars to not present consistently
                    }
            }
            
            .actionSheet(isPresented: $isShowingSortActionSheet) {
                ActionSheet(title: Text("Sort Results"), message: Text("Choose a method for sorting the results."), buttons: [
                        .default(Text("Sort by stat alphabetically")) {
                            sortMethod = SortMethods.byStatAlphabetically
                        },
                        .default(Text("Sort by stat reverse alphabetically")) {
                            sortMethod = SortMethods.byStatReverseAlphabetically
                        },
                        .default(Text("Sort by ranking ascending")) {
                            sortMethod = SortMethods.byRankingAscending
                        },
                        .default(Text("Sort by ranking descending")) {
                            sortMethod = SortMethods.byRankingDescending
                        },
                        .cancel()
                    ]
                )
            }
        }
        
        .task {
            if teamRankings.isEmpty {
                await refreshRankings()
            } else {
                print("We already have team data, not fetching onAppear")
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

struct SampleSheet: View {
    var body: some View {
        Text("Hello Sheet")
    }
}

struct RankingsView_Previews: PreviewProvider {
    static var previews: some View {
        RankingsView()
    }
}
