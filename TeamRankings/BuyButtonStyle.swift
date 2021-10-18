//
//  BuyButtonStyle.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/17/21.
//

import StoreKit
import SwiftUI

struct BuyButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        var bgColor: Color = Color.blue
        bgColor = configuration.isPressed ? bgColor.opacity(0.7) : bgColor.opacity(1)

        return configuration.label
            .frame(width: 50)
            .padding(10)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
