//
//  TopFourView.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/9/21.
//

import SwiftUI

struct TopFourView: View {
    @State private var teamRankings = [String:Int]()
    
    let widgetTeam = UserDefaults(suiteName: "group.com.ryantoken.teamrankings")?.string(forKey: "WidgetTeam") ?? "Air Force"
    
    var sortedDictionary: [Dictionary<String, Int>.Element] {
        print(teamRankings)
        let teamRankingsSorted = teamRankings.sorted{ $0.value < $1.value }
        if teamRankingsSorted.isEmpty {
            return []
        } else {
            let topFourSorted = teamRankingsSorted[...3]
            return Array(topFourSorted)
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text(widgetTeam)
            
            if !sortedDictionary.isEmpty {
                HStack {
                    Text("\(getHumanReadableStat(for: sortedDictionary[0].key)):")
                    Text(getHumanReadableRanking(for: sortedDictionary[0].value))
                    
                    Spacer()
                    
                    Text("\(getHumanReadableStat(for: sortedDictionary[1].key)):")
                    Text(getHumanReadableRanking(for: sortedDictionary[1].value))
                }
                
                HStack {
                    Text("\(getHumanReadableStat(for: sortedDictionary[2].key)):")
                    Text(getHumanReadableRanking(for: sortedDictionary[2].value))
                    
                    Spacer()
                    
                    Text("\(getHumanReadableStat(for: sortedDictionary[3].key)):")
                    Text(getHumanReadableRanking(for: sortedDictionary[3].value))
                }
            } else {
                Text("No data")
            }
        }
        .padding()
        .font(.headline)
        
        
        .task {
            print("refreshing rankings")
            await refreshRankings()
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
                let fetchedRankings = try await TeamFetcher.getTeamRankingsFor(team: widgetTeam)
                teamRankings = try fetchedRankings.allProperties()
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
}

//struct TopFourView_Previews: PreviewProvider {
//    static var previews: some View {
//        TopFourView(team: "Air Force", teamRankings: )
//    }
//}
