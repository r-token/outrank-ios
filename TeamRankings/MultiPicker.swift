//
//  MultiPicker.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct MultiPicker<LabelView: View, Selectable: Identifiable & Hashable>: View {
    let label: LabelView
    let allTeams: [Selectable]
    let teamToString: (Selectable) -> String

    var selectedCount: Int

    var body: some View {
        NavigationLink(destination: MultiPickerView()) {
            HStack {
                label
                Spacer()
                Text("\(selectedCount) Teams")
            }
        }
    }

    private func MultiPickerView() -> some View {
        TeamRankings.MultiPickerView(
            allTeams: allTeams,
            teamToString: teamToString,
            selectedCount: selectedCount
        )
    }
}


struct MultiPicker_Previews: PreviewProvider {
    struct IdentifiableString: Identifiable, Hashable {
        let string: String
        var id: String { string }
    }

    static var previews: some View {
        NavigationView {
            Form {
                MultiPicker<Text, IdentifiableString>(
                    label: Text("Favorite Teams"),
                    allTeams: ["A", "B", "C", "D"].map { IdentifiableString(string: $0) },
                    teamToString: { $0.string },
                    selectedCount: 4
                )
            }.navigationTitle("Settings")
        }
    }
}
