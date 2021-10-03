//
//  Test.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/3/21.
//

import SwiftUI

struct Test: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.red
                    .ignoresSafeArea()
                
                Text("Hi")
            }
            
            .navigationTitle("Hey")
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
