//
//  StatFetcher.swift
//  Outrank
//
//  Created by Ryan Token on 10/20/21.
//

import Foundation

struct StatFetcher {
    enum StatFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    static func getStatRankingsFor(stat: String) async throws -> Stat {
        print("getting rankings for \(stat)")
        let endpoint = "https://tapbejtlgh.execute-api.us-east-2.amazonaws.com/dev/singleStatQuery?stat=\(stat)"
        let cleanEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let finalEndpoint = cleanEndpoint.replacingOccurrences(of: "&", with: "%26")
        print(finalEndpoint)
        
        guard let url = URL(string: finalEndpoint) else {
            throw StatFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let statRankings = try JSONDecoder().decode(Stat.self, from: data)
        return statRankings
    }
}
