//
//  FavoriteTeamsSelectionView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct FavoriteTeamsSelectionView: View {
    @EnvironmentObject var favoriteTeams: FavoriteTeams
    let team: String
    
    var body: some View {
        HStack {
            favoriteTeams.contains(team) ?
                Text(team)
                .font(.headline)
                .foregroundColor(.primary)
            :
                Text(team)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()

            VStack {
                favoriteTeams.contains(team) ? Image(systemName: "star.fill") : Image(systemName: "star")
            }
            .foregroundColor(.yellow)
        }
    }
}
