//
//  MultiPickerView.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI
import CoreData

struct MultiPickerView<Selectable: Identifiable & Hashable>: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    var favorites: FetchedResults<Favorite>
    
    let allTeams: [Selectable]
    let teamToString: (Selectable) -> String

    var selectedCount: Int

    var body: some View {
        List {
            Section(header: Text("Favorite Teams")) {
                ForEach(favorites) { favorite in
                    Button(action: { toggleSelection(team: favorite.wrappedTeam) }) {
                        FavoriteTeamsSelectionView(team: favorite.wrappedTeam)
                            .font(.headline)
                    }
                }
                
                if favorites.isEmpty {
                    Text("No favorites yet ☹️")
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("All Teams")) {
                ForEach(allTeams) { team in
                    let team = teamToString(team)
                    
                    Button(action: { toggleSelection(team: team) }) {
                        FavoriteTeamsSelectionView(team: team)
                    }
                }
            }
        }
        
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleSelection(team: String) {
        if favoriteTeamsContains(team) {
            removeFavorite(team: team)
        } else {
            addFavorite(team: team)
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
    
    func addFavorite(team: String) {
        let favorite = Favorite(context: moc)
        favorite.team = team
        
        try? moc.save()
    }
    
    func removeFavorite(team: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        
        let result = try? moc.fetch(fetchRequest)
        let favorites = result as! [Favorite]
        
        for favorite in favorites {
            if favorite.wrappedTeam == team {
                moc.delete(favorite)
            }
        }
        
        do {
            try moc.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {

        }
    }
}

struct MultiPickerView_Previews: PreviewProvider {
    struct IdentifiableString: Identifiable, Hashable {
        let string: String
        var id: String { string }
    }

    @State static var selected: Set<IdentifiableString> = Set(["A", "C"].map { IdentifiableString(string: $0) })

    static var previews: some View {
        NavigationView {
            MultiPickerView(
                allTeams: ["A", "B", "C", "D"].map { IdentifiableString(string: $0) },
                teamToString: { $0.string },
                selectedCount: 4
            )
        }
    }
}
