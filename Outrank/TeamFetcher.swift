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
        
        // if it's earlier than 10:00am, get yesterday's data from 8:00am or later
        // if it's 10:00am or later local time, just get the data from today at 9:00 (14:00 UTC)
        var date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        var month = calendar.component(.month, from: date)
        var hour = calendar.component(.hour, from: date)
        var day = calendar.component(.day, from: date)
        
        if hour < 10 {
            date = Date().dayBefore
            year = calendar.component(.year, from: date)
            month = calendar.component(.month, from: date)
            hour = 8
            day = calendar.component(.day, from: date)
        } else {
            hour = 9
        }
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = 0
        date = Calendar.current.date(from: components) ?? Date.now
        print(date)
        
        let isoDate = Date.ISOStringFromDate(date: date)
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
        
        // if it's earlier than 10:00am, get yesterday's data from 8:00am or later
        // if it's 10:00am or later local time, just get the data from today at 9:00 (14:00 UTC)
        var date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        var month = calendar.component(.month, from: date)
        var hour = calendar.component(.hour, from: date)
        var day = calendar.component(.day, from: date)
        
        if hour < 10 {
            date = Date().dayBefore
            year = calendar.component(.year, from: date)
            month = calendar.component(.month, from: date)
            hour = 8
            day = calendar.component(.day, from: date)
        } else {
            hour = 9
        }
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = 0
        date = Calendar.current.date(from: components) ?? Date.now
        print(date)
        
        let isoDate = Date.ISOStringFromDate(date: date)
        print(isoDate)
        
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
