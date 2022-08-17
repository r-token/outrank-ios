//
//  HistoricalFetcher.swift
//  Outrank
//
//  Created by Ryan Token on 10/30/21.
//

import Foundation

struct HistoricalFetcher {
    enum HistoricalFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    static func getHistoricalRankingsFor(team: String, isoDate: String) async throws -> [Team] {
        print("getting rankings for \(team) after \(isoDate)")
        
        let endpoint = "https://8e7g6ojh8b.execute-api.us-east-2.amazonaws.com/historicalRankingsQuery?team=\(team)"
        let cleanEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpointWithoutAmpersands = cleanEndpoint.replacingOccurrences(of: "&", with: "%26")
        let finalEndpoint = endpointWithoutAmpersands+"&date=\(isoDate)"
        print(finalEndpoint)
        
        guard let url = URL(string: finalEndpoint) else {
            throw HistoricalFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let historicalRankings = try JSONDecoder().decode([Team].self, from: data)

        return historicalRankings
    }
    
}
