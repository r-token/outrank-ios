//
//  InfoView.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

enum Source {
    case rankings
    case compare
}

struct InfoView: View {
    let source: Source
    
    var body: some View {
        switch source {
        case .rankings:
            VStack(alignment: .leading, spacing: 10) {
                Text("Rankings Color Guide")
                    .font(.largeTitle)
                    .padding(15)
                
                Group {
                    Text("On this page, a ")
                    +
                    Text("green ranking ")
                        .foregroundColor(.green)
                        .font(.headline)
                    +
                    Text("means the team ranks in the *top half* of the country. A ")
                    +
                    Text("red ranking ")
                        .foregroundColor(.red)
                        .font(.headline)
                    +
                    Text("means the team ranks in the *bottom half*.")
                }
                .padding(15)
                
                Group {
                    Text("The ranking colors work differently on the **Compare** page.")
                }
                .padding(15)

                
                Spacer()
            }
            .padding(.top)
            .padding()
            
        case .compare:
            VStack(alignment: .leading, spacing: 10) {
                Text("Compare Color Guide")
                    .font(.largeTitle)
                    .padding(15)
                
                Group {
                    Text("On this page, a ")
                    +
                    Text("green ranking ")
                        .foregroundColor(.green)
                        .font(.headline)
                    +
                    Text("means the team ranks *better* on a given stat than the team you're comparing them with. A ")
                    +
                    Text("red ranking ")
                        .foregroundColor(.red)
                        .font(.headline)
                    +
                    Text("means the team ranks *worse* than the other team.")
                }
                .padding(15)
                
                Group {
                    Text("The ranking colors work differently on the **Rankings** page.")
                }
                .padding(15)

                
                Spacer()
            }
            .padding(.top)
            .padding()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(source: Source.compare)
    }
}
