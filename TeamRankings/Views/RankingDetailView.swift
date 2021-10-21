//
//  RankingDetailView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/4/21.
//

import SwiftUI

struct RankingDetailView: View {
    @State private var statRankings = [String:Int]()
    @State private var apiError = false
    
    let team: String
    let stat: String
    let humanReadableStat: String
    let ranking: Int
    let humanReadableRanking: String
    
    var sortedRankings: [Dictionary<String, Int>.Element]{
        return statRankings.sorted{ $0.value < $1.value }
    }
    
    let statDescriptions = [
        "BlockedKicks": "Total number of kicks a team has blocked.",
        "FewestPenaltiesPerGame": "Average number of penalties a team commits per game. Lower number = fewer penalties.",
        "FourthDownConversionPctDefense": "Percentage of the time opposing teams convert on 4th down.",
        "TotalDefense": "Average number of yards allowed per game.",
        "TacklesForLossAllowed": "Average number of times per game a team's offense allows a TFL.",
        "KickoffReturnDefense": "Average number of yards a team gives up on kickoff returns.",
        "RedZoneOffense": "Percentage of the time a team scores a field goal or touchdown once they've entered the red zone.",
        "TeamSacks": "Average number of sacks a team gets per game.",
        "BlockedPunts": "Total number of punts a team has blocked.",
        "PassesIntercepted": "Total number of times a team has intercepted a pass.",
        "PassingYardsAllowed": "Average number of passing yards a team allows per game.",
        "ThirdDownConversionPct": "Percentage of the time a team converts on 1st down.",
        "KickoffReturns": "Average number of yards a team gains on kickoff returns per game.",
        "FewestPenaltyYardsPerGame": "Average number of penalty yards a team gives up per game. Lower number = fewer penalty yards.",
        "RushingOffense": "Average number of rushing yards a team gains per game.",
        "PassesHadIntercepted": "Total number of interceptions a team has thrown.",
        "FirstDownsOffense": "Total number of first downs a team has gained.",
        "TimeOfPossession": "Average amount of time a team controlled possession per game.",
        "PuntReturns": "Average number of punt return yards a team gains per game.",
        "BlockedKicksAllowed": "Total number of kicks a team has had blocked.",
        "FewestPenalties": "Total number of penalties a team has committed. Lower number = fewer penalties.",
        "FumblesRecovered": "Total number of fumbles a team has recovered.",
        "BlockedPuntsAllowed": "Total number of punts a team has had blocked.",
        "RedZoneDefense": "Percentage of the time the opposing team scores a field goal or touchdown once they've entered the red zone.",
        "PuntReturnDefense": "Average number of yards a team gives up on punt returns per game.",
        "TurnoversLost": "Total number of turnovers a team has committed (fumbles loset and interceptions thrown).",
        "NetPunting": "Average yards per punt - average punt return yards allowed",
        "FewestPenaltyYards": "Total number of penalty yards a team has allowed.",
        "TurnoverMargin": "Average number of turnovers caused - turnovers lost per game. Lower number = better margin, meaning a team causes more turnovers than they lose.",
        "FirstDownsDefense": "Total number of first downs a team has allowed to opposing teams.",
        "TeamTacklesForLoss": "Average number of tackles for loss a team makes per game.",
        "RushingDefense": "Average number of rushing yards a team allows per game.",
        "SacksAllowed": "Average number of sacks a team takes per game.",
        "TeamPassingEfficiency": "Such a ridiculous calculation. Seriously, what is this? But if you really want to know, it's: (completion percentage + (yards per pass attempt * 8.4) + (touchdowns per pass attempt * 100 * 3.3)) - (interceptions per pass attempt * 100 * 2). Wow.",
        "WinningPercentage": "Percentage of the time a team wins their games.",
        "DefensiveTDs": "Total number of defensive touchdowns a team has scored. Includes fumble recovery touchdowns and pick sixes.",
        "FourthDownConversionPct": "Percentage of the time a team converts on fourth down.",
        "ScoringDefense": "Average number of points a defense allows per game. Lower number = fewer points allowed.",
        "ScoringOffense": "Average number of points an offense scores per game.",
        "FumblesLost": "Total number of fumbles a team has lost.",
        "TeamPassingEfficiencyDefense": "Another ridiculous calculation. Go look at the description for 'Team Passing Efficiency', and this stat is just how good a given team is at keeping opposing teams' Team Passing Efficiency low.",
        "CompletionPercentage": "Percentage of the time a team completes pass attempts.",
        "TotalOffense": "Average number of yards an offense gains per game.",
        "PassingYardsPerCompletion": "Average number of passing yards gained per completion.",
        "PassingOffense": "Average number of passing yards a team gains per game.",
        "ThirdDownConversionPctDefense": "Percentage of the time opposing teams convert on 3rd down.",
        "TurnoversGained": "Total number of turnovers a team has gained. Includes fumble recoveries and passes intercepted."
    ]
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("\(team)'s Ranking:")
                        .foregroundColor(.primary)
                    
                    Text(humanReadableRanking)
                        .foregroundColor(ranking < 65 ? .green : .red)
                }
                .font(.headline)
            }
            
            Section {
                Text("Description:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(statDescriptions[stat] ?? "Description Unknown.")
                    .foregroundColor(.gray)
            }
            
            Section {
                Text("All Rankings For This Stat:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                ForEach(sortedRankings, id: \.self.key) { item in
                    HStack(alignment: .center, spacing: 8) {
                        Text(Conversions.getHumanReadableTeam(from: item.key))
                        
                        Spacer()
                        
                        Text(Conversions.getHumanReadableRanking(for: item.value))
                            .foregroundColor(item.value < 65 ? .green : .red)
                    }
                }
                
                if apiError {
                    Text("😕 Error loading rankings for \(humanReadableStat).")
                        .foregroundColor(.gray)
                }
            }
        }
        .animation(.default, value: statRankings)
        
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(humanReadableStat)
                    .font(.headline)
            }
        }
        
        .task {
            if statRankings.isEmpty {
                await getRankingsForStat()
            } else {
                print("We already have stat ranking data for this stat, not fetching onAppear")
            }
        }
    }
    
    func getRankingsForStat() async {
        Task {
            print("fetching rankings for stat")
            do {
                let fetchedRankings = try await StatFetcher.getStatRankingsFor(stat: stat)
                statRankings = try fetchedRankings.allProperties()
                apiError = false
            } catch {
                print("Request failed with error: \(error)")
                apiError = true
            }
        }
    }
}

struct RankingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RankingDetailView(team: "Tulsa", stat: "FewestPenaltyYardsPerGame", humanReadableStat: "Fewest Penalty Yards Per Game", ranking: 19, humanReadableRanking: "19th")
    }
}

