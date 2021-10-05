//
//  AllTeams.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import Foundation

struct AllTeams {
    private var allTeams: [String]
    
    init() {
        // load our saved data

        // still here? Use an empty array
        allTeams = [
          "Air Force",
          "Akron",
          "Alabama",
          "App State",
          "Arizona",
          "Arizona St.",
          "Arkansas",
          "Arkansas St.",
          "Army West Point",
          "Auburn",
          "Ball St.",
          "Baylor",
          "Boise St.",
          "Boston College",
          "Bowling Green",
          "Buffalo",
          "BYU",
          "California",
          "Central Mich.",
          "Charlotte",
          "Cincinnati",
          "Clemson",
          "Coastal Carolina",
          "Colorado",
          "Colorado St.",
          "Duke",
          "East Carolina",
          "Eastern Mich.",
          "FIU",
          "Fla. Atlantic",
          "Florida",
          "Florida St.",
          "Fresno St.",
          "Ga. Southern",
          "Georgia",
          "Georgia St.",
          "Georgia Tech",
          "Hawaii",
          "Houston",
          "Illinois",
          "Indiana",
          "Iowa",
          "Iowa St.",
          "Kansas",
          "Kansas St.",
          "Kent St.",
          "Kentucky",
          "Liberty",
          "Louisiana",
          "Louisiana Tech",
          "Louisville",
          "LSU",
          "Marshall",
          "Maryland",
          "Massachusetts",
          "Memphis",
          "Miami (FL)",
          "Miami (OH)",
          "Michigan",
          "Michigan St.",
          "Middle Tenn.",
          "Minnesota",
          "Mississippi St.",
          "Missouri",
          "Navy",
          "NC State",
          "Nebraska",
          "Nevada",
          "New Mexico",
          "New Mexico St.",
          "North Carolina",
          "North Texas",
          "Northern Ill.",
          "Northwestern",
          "Notre Dame",
          "Ohio",
          "Ohio St.",
          "Oklahoma",
          "Oklahoma St.",
          "Old Dominion",
          "Ole Miss",
          "Oregon",
          "Oregon St.",
          "Penn St.",
          "Pittsburgh",
          "Purdue",
          "Rice",
          "Rutgers",
          "SMU",
          "San Diego St.",
          "San Jose St.",
          "South Alabama",
          "South Carolina",
          "South Fla.",
          "Southern California",
          "Southern Miss.",
          "Stanford",
          "Syracuse",
          "TCU",
          "Temple",
          "Tennessee",
          "Texas",
          "Texas A&M",
          "Texas St.",
          "Texas Tech",
          "Toledo",
          "Tulane",
          "Tulsa",
          "Troy",
          "UAB",
          "UCF",
          "UCLA",
          "UConn",
          "ULM",
          "UNLV",
          "UTEP",
          "UTSA",
          "Utah",
          "Utah St.",
          "Vanderbilt",
          "Virginia",
          "Virginia Tech",
          "Washington",
          "Washington St.",
          "Wake Forest",
          "West Virginia",
          "Western Ky.",
          "Western Mich.",
          "Wisconsin",
          "Wyoming"
        ]
    }
    
    func getTeams() -> [String] {
        return allTeams
    }
}
