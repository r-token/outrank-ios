//
//  TopFourView.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/9/21.
//

import SwiftUI

struct TopOrBottomFourView: View {
    var type: WidgetType
    var teamRankings: [String:Int]
    
    enum WidgetType {
        case topFour
        case bottomFour
    }
    
    let widgetTeam = UserDefaults(suiteName: "group.com.ryantoken.teamrankings")?.string(forKey: "WidgetTeam") ?? "Air Force"
    
    var sortedDictionary: [Dictionary<String, Int>.Element] {
        if type == WidgetType.topFour {
            let teamRankingsSorted = teamRankings.sorted{ $0.value < $1.value }
            if teamRankingsSorted.isEmpty {
                return []
            } else {
                let topFourSorted = teamRankingsSorted[...3]
                return Array(topFourSorted)
            }
        } else {
            let teamRankingsSorted = teamRankings.sorted{ $0.value > $1.value }
            if teamRankingsSorted.isEmpty {
                return []
            } else {
                let bottomFourSorted = teamRankingsSorted[...3]
                return Array(bottomFourSorted)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 6) {
            if type == WidgetType.topFour {
                Text("\(widgetTeam)'s Top Four")
                    .foregroundColor(.gray)
            } else {
                Text("\(widgetTeam)'s Bottom Four")
                    .foregroundColor(.gray)
            }
            
            if !sortedDictionary.isEmpty {
                HStack {
                    Text("\(getHumanReadableStat(for: sortedDictionary[0].key)):")
                    
                    Spacer()
                    
                    Text(getHumanReadableRanking(for: sortedDictionary[0].value))
                        .foregroundColor(type == WidgetType.topFour ? .green : .red)
                    
                }
                
                HStack {
                    
                    Text("\(getHumanReadableStat(for: sortedDictionary[1].key)):")
                    
                    Spacer()
                    
                    Text(getHumanReadableRanking(for: sortedDictionary[1].value))
                        .foregroundColor(type == WidgetType.topFour ? .green : .red)
                }
                
                HStack {
                    Text("\(getHumanReadableStat(for: sortedDictionary[2].key)):")
                    
                    Spacer()
                    
                    Text(getHumanReadableRanking(for: sortedDictionary[2].value))
                        .foregroundColor(type == WidgetType.topFour ? .green : .red)
                    
                }
                
                HStack {
                    Text("\(getHumanReadableStat(for: sortedDictionary[3].key)):")
                    
                    Spacer()
                    
                    Text(getHumanReadableRanking(for: sortedDictionary[3].value))
                        .foregroundColor(type == WidgetType.topFour ? .green : .red)
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

struct TopOrBottomFourView_Previews: PreviewProvider {
    static var previews: some View {
        do {
            return TopOrBottomFourView(type: TopOrBottomFourView.WidgetType.topFour, teamRankings: try Team.exampleTeam.allProperties())

        } catch {
            return TopOrBottomFourView(type: TopOrBottomFourView.WidgetType.topFour, teamRankings: ["test":99999])
        }
    }
}
