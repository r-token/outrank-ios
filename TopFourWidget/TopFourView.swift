//
//  TopFourView.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/9/21.
//

import SwiftUI

struct TopFourView: View {
    var teamRankings: [String:Int]
    
    let widgetTeam = UserDefaults(suiteName: "group.com.ryantoken.teamrankings")?.string(forKey: "WidgetTeam") ?? "Air Force"
    
    var sortedDictionary: [Dictionary<String, Int>.Element] {
        let teamRankingsSorted = teamRankings.sorted{ $0.value < $1.value }
        if teamRankingsSorted.isEmpty {
            return []
        } else {
            let topFourSorted = teamRankingsSorted[...3]
            return Array(topFourSorted)
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(widgetTeam)'s Top Four")
                .foregroundColor(.gray)
            
            if !sortedDictionary.isEmpty {
                HStack {
                    Text("\(getHumanReadableStat(for: sortedDictionary[0].key)):")
                    
                    Spacer()
                    
                    Text(getHumanReadableRanking(for: sortedDictionary[0].value))
                        .foregroundColor(.green)
                    
                }
                
                HStack {
                    
                    Text("\(getHumanReadableStat(for: sortedDictionary[1].key)):")
                    
                    Spacer()
                    
                    Text(getHumanReadableRanking(for: sortedDictionary[1].value))
                        .foregroundColor(.green)
                }
                
                HStack {
                    Text("\(getHumanReadableStat(for: sortedDictionary[2].key)):")
                    
                    Spacer()
                    
                    Text(getHumanReadableRanking(for: sortedDictionary[2].value))
                        .foregroundColor(.green)
                    
                }
                
                HStack {
                    Text("\(getHumanReadableStat(for: sortedDictionary[3].key)):")
                    
                    Spacer()
                    
                    Text(getHumanReadableRanking(for: sortedDictionary[3].value))
                        .foregroundColor(.green)
                }
            } else {
                Text("No Data")
            }
        }
        .padding()
        .font(.headline)
        .foregroundColor(.primary)
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

struct TopFourView_Previews: PreviewProvider {
    static var previews: some View {
        do {
            return TopFourView(teamRankings: try Team.exampleTeam.allProperties())

        } catch {
            return TopFourView(teamRankings: ["test":99999])
        }
    }
}
