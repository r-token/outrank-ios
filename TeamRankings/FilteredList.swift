//
//  FilteredList.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/24/21.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content
    
    init(filterKey: String, filterValue: String, sortDescriptors: [NSSortDescriptor], predicate: String, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "%K \(predicate.uppercased())[c] %@", filterKey, filterValue))
        self.content = content
    }

    var body: some View {
        ForEach(fetchRequest.wrappedValue, id: \.self) { item in
            content(item)
        }
    }
}
