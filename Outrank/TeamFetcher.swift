//
//  TeamFetcher.swift
//  Outrank
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
        print("getting rankings for \(team)")
        
        let earlyDate = Calendar.current.date(
          byAdding: .hour,
          value: -12,
          to: Date())
        
        let isoDate = Date.ISOStringFromDate(date: earlyDate!)
        print(isoDate)
        
        let endpoint = "https://tapbejtlgh.execute-api.us-east-2.amazonaws.com/dev/singleTeamQueryV2?team=\(team)"
        let cleanEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpointWithoutAmpersands = cleanEndpoint.replacingOccurrences(of: "&", with: "%26")
        let finalEndpoint = endpointWithoutAmpersands+"&date=\(isoDate)"
        print(finalEndpoint)
        
        guard let url = URL(string: finalEndpoint) else {
            throw TeamFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let teamRankings = try JSONDecoder().decode(Team.self, from: data)
        return teamRankings
    }
    
    static func dispatchQueueGetTeamRankingsFor(team: String, completion: @escaping ([String:Int]) -> Void) -> Void {
        print("refreshing data via dispatchQueue")
        
        let earlyDate = Calendar.current.date(
          byAdding: .hour,
          value: -12,
          to: Date())
        
        let isoDate = Date.ISOStringFromDate(date: earlyDate!)
        
        let endpoint = "https://tapbejtlgh.execute-api.us-east-2.amazonaws.com/dev/singleTeamQueryV2?team=\(team)"
        let cleanEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpointWithoutAmpersands = cleanEndpoint.replacingOccurrences(of: "&", with: "%26")
        let finalEndpoint = endpointWithoutAmpersands+"&date=\(isoDate)"
        print(finalEndpoint)
        
        guard let url = URL(string: finalEndpoint) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let requestTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            if(error != nil) {
                print("Error: \(error!)")
            } else {
                do {
                    let teamRankings  = try JSONDecoder().decode(Team.self, from: data!)
                    //send this block to required place
                    completion(try teamRankings.allProperties())
                } catch {
                    print("network error")
                }
            }
        }
        requestTask.resume()
    }
}
