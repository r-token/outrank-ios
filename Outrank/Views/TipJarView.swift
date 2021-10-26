//
//  TipJarView.swift
//  Outrank
//
//  Created by Ryan Token on 10/6/21.
//

import SwiftUI

struct TipJarView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                Section(header: Text("Tip Options")) {
                    ForEach(store.tips, id: \.id) { tip in
                        ListTipOptionsView(product: tip)
                    }
                }
                
                Section {
                    Text("Outrank is free with no ads. If you find it useful, please consider supporting development by leaving a tip.")
                        .foregroundColor(.gray)
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            .navigationTitle("Tip Jar")
        }
    }
}

struct TipJarView_Previews: PreviewProvider {
    static var previews: some View {
        TipJarView()
    }
}
