//
//  Favorite+CoreDataProperties.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/24/21.
//
//

import Foundation
import CoreData


extension Favorite {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var team: String?
    
    public var wrappedTeam: String {
        return team ?? "Unknown"
    }
}

extension Favorite : Identifiable {

}
