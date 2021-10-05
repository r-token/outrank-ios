//
//  FavoriteTeams.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import Foundation

class FavoriteTeams: ObservableObject {
    // the actual resorts the user has favorited
    private var teams: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "FavoriteTeams"
    
    static let exampleTeams = ["Tulsa", "Tulane", "SMU"]

    init() {
        // load our saved data
        if let savedData = UserDefaults.standard.data(forKey: saveKey) {
            let decoder = JSONDecoder()
            do {
                teams = try decoder.decode(Set<String>.self, from: savedData)
            } catch {
                print("decoding failed")
                teams = []
            }
        } else {
            print("no favorite teams")
            teams = []
        }
    }

    // returns true if our set contains this resort
    func contains(_ team: String) -> Bool {
        teams.contains(team)
    }
    
    func getFavorites() -> Set<String> {
        return teams
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ team: String) {
        objectWillChange.send()
        teams.insert(team)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ team: String) {
        objectWillChange.send()
        teams.remove(team)
        save()
    }

    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(teams)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("encoding failed")
        }
    }
}
