//
//  ComparisonView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct ComparisonView: View {
    @State private var teamOne = UserDefaults.standard.string(forKey: "TeamOne") ?? "Tulsa"
    @State private var teamTwo = UserDefaults.standard.string(forKey: "TeamTwo") ?? "SMU"
    
    @State private var teamOneRankings = [String:Int]()
    @State private var teamTwoRankings = [String:Int]()
    
    @State private var isShowingTeamOnePickerView = false
    @State private var isShowingTeamTwoPickerView = false
    
    var sortedTeamOneRankings: [Dictionary<String, Int>.Element]{
        return teamOneRankings.sorted{ $0.value < $1.value }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        isShowingTeamOnePickerView = true
                    }) {
                        Text(teamOne)
                    }
                    .buttonStyle(GrowingButton())
                    
                    Spacer()
                    
                    Button(action: {
                        swapTeams()
                    }) {
                        Image(systemName: "arrow.left.arrow.right.square")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                    
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingTeamTwoPickerView = true
                    }) {
                        Text(teamTwo)
                    }
                    .buttonStyle(GrowingButton())
                }
                .padding(.horizontal)
                
                HStack(spacing: 5) {
                    Text("Sorted by")
                    Image(systemName: "arrow.up.left")
                    Text("team's best rankings")
                }
                .padding(.vertical, 5)
                .font(.subheadline)
                .foregroundColor(.gray)
                
                List {
                    ForEach(sortedTeamOneRankings, id: \.self.key) { item in
                        VStack {
                            Text(getHumanReadableStat(for: item.key))
                                .font(.headline)
                            
                            Spacer()
                            
                            HStack {
                                if item.value < teamTwoRankings[item.key] ?? 99999 {
                                    Text(getHumanReadableRanking(for: item.value))
                                        .foregroundColor(.green)
                                } else if item.value > teamTwoRankings[item.key] ?? 99999 {
                                    Text(getHumanReadableRanking(for: item.value))
                                        .foregroundColor(.red)
                                } else {
                                    Text(getHumanReadableRanking(for: item.value))
                                        .foregroundColor(.yellow)
                                }
                                
                                Spacer()
                                
                                if item.value > teamTwoRankings[item.key] ?? 99999 {
                                    Text(getHumanReadableRanking(for: teamTwoRankings[item.key] ?? 99999))
                                        .foregroundColor(.green)
                                } else if item.value < teamTwoRankings[item.key] ?? 99999 {
                                    Text(getHumanReadableRanking(for: teamTwoRankings[item.key] ?? 99999))
                                        .foregroundColor(.red)
                                } else {
                                    Text(getHumanReadableRanking(for: teamTwoRankings[item.key] ?? 99999))
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 3)
                        }
                    }
                }
                .refreshable {
                    await refreshRankings()
                }
                
                .animation(.default, value: teamOneRankings)
            }
            
            .navigationTitle("Compare Teams")
            .navigationBarTitleDisplayMode(.inline)
            
            .sheet(isPresented: $isShowingTeamOnePickerView) {
                TeamPickerView(team: $teamOne, teamRankings: $teamOneRankings, type: TeamPickerView.TeamPickerTypes.comparisonTeamOne)
            }
            
            .sheet(isPresented: $isShowingTeamTwoPickerView) {
                TeamPickerView(team: $teamTwo, teamRankings: $teamTwoRankings, type: TeamPickerView.TeamPickerTypes.comparisonTeamTwo)
            }
            
            .task {
                if teamOneRankings.isEmpty && teamTwoRankings.isEmpty {
                    await refreshRankings()
                } else {
                    print("We already have comparison data, not fetching onAppear")
                }
            }
        }
    }
    
    func swapTeams() {
        let tempTeamOne = teamOne
        let tempTeamTwo = teamTwo
        let tempTeamOneRankings = teamOneRankings
        let tempTeamTwoRankings = teamTwoRankings
        
        teamOne = tempTeamTwo
        teamTwo = tempTeamOne
        teamOneRankings = tempTeamTwoRankings
        teamTwoRankings = tempTeamOneRankings
        
        UserDefaults.standard.set(tempTeamTwo, forKey: "TeamOne")
        UserDefaults.standard.set(tempTeamOne, forKey: "TeamTwo")
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
            do {
                async let teamOneFetched = try TeamFetcher.getTeamRankingsFor(team: teamOne)
                async let teamTwoFetched = try TeamFetcher.getTeamRankingsFor(team: teamTwo)
                
                let rankingsForTeamOne = try await teamOneFetched.allProperties()
                let rankingsForTeamTwo = try await teamTwoFetched.allProperties()
                
                teamOneRankings = rankingsForTeamOne
                teamTwoRankings = rankingsForTeamTwo
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
}

struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonView()
    }
}
