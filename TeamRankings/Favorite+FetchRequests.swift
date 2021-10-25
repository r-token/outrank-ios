//
//  Favorite+FetchRequests.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/24/21.
//

import CoreData

extension Favorite {
  static var allFavoritesFetchRequest: NSFetchRequest<Favorite> {
      let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(keyPath: \Favorite.team, ascending: true)]

      return request
  }
}
