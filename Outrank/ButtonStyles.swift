//
//  ButtonStyles.swift
//  Outrank
//
//  Created by Ryan Token on 10/3/21.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(colorScheme == .light ? Color.evenLighterDarkGreen : Color.somewhatLighterDarkGreen)
            .foregroundColor(colorScheme == .light ? .white : .lighterGray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: colorScheme == .light ? .gray : .black, radius: 5, x: 0, y: 5)
            .font(.headline)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct BuyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        var bgColor: Color = Color.green
        bgColor = configuration.isPressed ? bgColor.opacity(0.7) : bgColor.opacity(1)

        return configuration.label
            .frame(width: 50)
            .padding(10)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct SubscribeButtonStyle: ButtonStyle {
    let isPurchased: Bool

    init(isPurchased: Bool = false) {
        self.isPurchased = isPurchased
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        var bgColor: Color = isPurchased ? Color.green : Color.somewhatLighterDarkGreen
        bgColor = configuration.isPressed ? bgColor.opacity(0.7) : bgColor.opacity(1)

        return configuration.label
            .frame(width: 50)
            .padding(10)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
