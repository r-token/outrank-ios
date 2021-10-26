//
//  WelcomeView.swift
//  Outrank
//
//  Created by Ryan Token on 10/22/21.
//

import SwiftUI

struct iPadWelcomeView: View {
    var type: WelcomeViewType
    
    enum WelcomeViewType {
        case rankings
        case settings
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image("Outrank")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text("Welcome to Outrank!")
                .font(.largeTitle)

            switch type {
            case WelcomeViewType.rankings:
                Text("Select a stat from the left-hand menu; swipe from the left edge to show it.")
                    .foregroundColor(.secondary)
            case WelcomeViewType.settings:
                Text("Select a setting from the left-hand menu; swipe from the left edge to show it.")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct iPadWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        iPadWelcomeView(type: iPadWelcomeView.WelcomeViewType.rankings)
    }
}
