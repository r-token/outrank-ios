//
//  Utils.swift
//  Outrank
//
//  Created by Ryan Token on 10/23/21.
//

import Foundation

class Utils {
    static func getSimpleAverageFor(_ teamRankings: [String:Int]) -> String {
        if teamRankings.isEmpty {
            return ""
        } else {
            var rankings = Array(teamRankings.values)
            rankings.removeAll { number in
                return number == 99999
            }
            let sumRankings = rankings.reduce(0, +)
            if sumRankings != 0 {
                let averageRankings = sumRankings / rankings.count
                return String(averageRankings)
            } else {
                return "0"
            }
        }
    }
}
