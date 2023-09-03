//
//  OutrankApp.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

@main
struct OutrankApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemBlue
    }
    
    var body: some Scene {
        WindowGroup {
            
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
