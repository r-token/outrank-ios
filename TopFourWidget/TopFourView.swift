//
//  TopFourView.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/9/21.
//

import SwiftUI

struct TopFourView: View {
    let team = UserDefaults.standard.string(forKey: "CurrentTeam") ?? "Air Force"
    let topFour: [String:Int]
    
    var sortedDictionary: [Dictionary<String, Int>.Element] {
        let allRankingsSorted = topFour.sorted{ $0.value < $1.value }
        let topFourSorted = allRankingsSorted[...3]
        return Array(topFourSorted)
    }
    
    var body: some View {
        VStack(spacing: 30) {
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
        }
        .padding()
        .font(.headline)
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
        TopFourView(topFour: ["test1":1, "test2":3, "test3": 51, "test4": 86])
    }
}
