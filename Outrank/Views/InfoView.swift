//
//  InfoView.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

enum Source {
    case rankings
    case compare
}

struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    let source: Source
    
    var body: some View {
        NavigationView {
            switch source {
            case .rankings:
                VStack(alignment: .leading) {
                    Text("**Rankings** page colors")
                        .font(.headline)
                        .padding(.horizontal)
                    
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
                    .foregroundColor(.gray)
                    .padding(15)
                    
                    Group {
                        Text("The colors work differently on the **Compare** page.")
                    }
                    .foregroundColor(.gray)
                    .padding(15)

                    
                    Spacer()
                }
                .padding(.top)
                .padding()
                
                .navigationTitle("Info")
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Done")
                        }
                    }
                }
                
            case .compare:
                VStack(alignment: .leading) {
                    Text("**Comparison** page colors")
                        .font(.headline)
                        .padding(.horizontal)
                    
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
                    .foregroundColor(.gray)
                    .padding(15)
                    
                    Group {
                        Text("The colors work differently on the **Rankings** page.")
                    }
                    .foregroundColor(.gray)
                    .padding(15)

                    
                    Spacer()
                }
                .padding(.top)
                .padding()
                
                .navigationTitle("Info")
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Done")
                        }
                    }
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(source: Source.rankings)
    }
}
