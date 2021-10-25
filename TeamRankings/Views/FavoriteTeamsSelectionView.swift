//
//  FavoriteTeamsSelectionView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI
import CoreData

struct FavoriteTeamsSelectionView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    var favorites: FetchedResults<Favorite>
    
    let team: String
    
    var body: some View {
        HStack {
            favoriteTeamsContains(team) ?
                Text(team)
                .font(.headline)
                .foregroundColor(.primary)
            :
                Text(team)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()

            VStack {
                favoriteTeamsContains(team) ? Image(systemName: "star.fill") : Image(systemName: "star")
            }
            .foregroundColor(.yellow)
        }
    }
    
    func favoriteTeamsContains(_ team: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        let predicate = NSPredicate(format: "team == %@", team)
        request.predicate = predicate
        request.fetchLimit = 1

        do{
            let count = try moc.count(for: request)
            if(count == 0){
                return false
            }
            else{
                return true
            }
          }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return false
    }
}
