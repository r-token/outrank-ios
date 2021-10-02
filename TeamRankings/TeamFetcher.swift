//
//  TeamFetcher.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

struct TeamFetcher {
    
    enum TeamFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    static func getTeamRankingsFor(team: String) async throws -> Team {
        let endpoint = "https://tapbejtlgh.execute-api.us-east-2.amazonaws.com/dev/singleTeamQuery?team=\(team)"
        let cleanEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: cleanEndpoint) else {
            throw TeamFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let teamRankings = try JSONDecoder().decode(Team.self, from: data)
        return teamRankings
    }
    
    
}
