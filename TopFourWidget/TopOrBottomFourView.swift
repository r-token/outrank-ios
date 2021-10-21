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
        var rankings = teamRankings
        // remove 99999 (aka "Unknown") values from the widgets
        for (key, value) in rankings where value == 99999 {
            rankings.removeValue(forKey: key)
        }
        
        if type == WidgetType.topFour {
            let teamRankingsSorted = rankings.sorted{ $0.value < $1.value }
            if teamRankingsSorted.isEmpty {
                return []
            } else {
                let topFourSorted = teamRankingsSorted[...3]
                return Array(topFourSorted)
            }
        } else {
            let teamRankingsSorted = rankings.sorted{ $0.value > $1.value }
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
                    Text("\(Conversions.getHumanReadableStat(for: sortedDictionary[0].key)):")
                    
                    Spacer()
                    
                    Text(Conversions.getHumanReadableRanking(for: sortedDictionary[0].value))
                        .foregroundColor(type == WidgetType.topFour ? .green : .red)
                    
                }
                
                HStack {
                    
                    Text("\(Conversions.getHumanReadableStat(for: sortedDictionary[1].key)):")
                    
                    Spacer()
                    
                    Text(Conversions.getHumanReadableRanking(for: sortedDictionary[1].value))
                        .foregroundColor(type == WidgetType.topFour ? .green : .red)
                }
                
                HStack {
                    Text("\(Conversions.getHumanReadableStat(for: sortedDictionary[2].key)):")
                    
                    Spacer()
                    
                    Text(Conversions.getHumanReadableRanking(for: sortedDictionary[2].value))
                        .foregroundColor(type == WidgetType.topFour ? .green : .red)
                    
                }
                
                HStack {
                    Text("\(Conversions.getHumanReadableStat(for: sortedDictionary[3].key)):")
                    
                    Spacer()
                    
                    Text(Conversions.getHumanReadableRanking(for: sortedDictionary[3].value))
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
