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
            Text(team)
                .foregroundColor(.primary)
            Spacer()

            VStack {
                favoriteTeams.contains(team) ? Image(systemName: "star.fill") : Image(systemName: "star")
            }
            .foregroundColor(.yellow)
        }
    }
}
