//
//  TabController.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

enum Tab {
    case rankings
    case compare
    case settings
}

class TabController: ObservableObject {
    @Published var activeTab = Tab.rankings

    func open(_ tab: Tab) {
        activeTab = tab
    }
}
