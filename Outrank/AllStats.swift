//
//  AllStats.swift
//  Outrank
//
//  Created by Ryan Token on 11/7/21.
//

import Foundation

struct AllStats {
    private var allStats: [String]
    
    init() {
        allStats = [
            "BlockedKicks",
            "FewestPenaltiesPerGame",
            "FourthDownConversionPctDefense",
            "TotalDefense",
            "TacklesForLossAllowed",
            "KickoffReturnDefense",
            "RedZoneOffense",
            "TeamSacks",
            "BlockedPunts",
            "PassesIntercepted",
            "PassingYardsAllowed",
            "ThirdDownConversionPct",
            "KickoffReturns",
            "FewestPenaltyYardsPerGame",
            "RushingOffense",
            "PassesHadIntercepted",
            "FirstDownsOffense",
            "TimeOfPossession",
            "PuntReturns",
            "BlockedKicksAllowed",
            "FewestPenalties",
            "FumblesRecovered",
            "BlockedPuntsAllowed",
            "RedZoneDefense",
            "PuntReturnDefense",
            "TurnoversLost",
            "NetPunting",
            "FewestPenaltyYards",
            "TurnoverMargin",
            "FirstDownsDefense",
            "TeamTacklesForLoss",
            "RushingDefense",
            "SacksAllowed",
            "TeamPassingEfficiency",
            "WinningPercentage",
            "DefensiveTDs",
            "FourthDownConversionPct",
            "ScoringDefense",
            "ScoringOffense",
            "FumblesLost",
            "TeamPassingEfficiencyDefense",
            "CompletionPercentage",
            "TotalOffense",
            "PassingYardsPerCompletion",
            "PassingOffense",
            "ThirdDownConversionPctDefense",
            "TurnoversGained"
        ]
    }
    
    func getStats() -> [String] {
        return allStats.sorted()
    }
}
