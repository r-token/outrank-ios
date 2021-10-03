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
        return teamOneRankings.sorted{ $0.key < $1.key }
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
                            .font(.title)
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
                .padding()
                
                Spacer()
                
                List {
                    ForEach(sortedTeamOneRankings, id: \.self.key) { item in
                        VStack {
                            Text(getHumanReadableStat(for: item.key))
                                .font(.headline)
                            
                            Spacer()
                            
                            HStack {
                                Text(getHumanReadableRanking(for: item.value))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text(getHumanReadableRanking(for: teamTwoRankings[item.key] ?? 99999))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 3)
                        }
                    }
                }
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
}

struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonView()
    }
}
