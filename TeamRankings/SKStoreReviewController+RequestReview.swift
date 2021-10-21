//
//  SKStoreReviewController+RequestReview.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/21/21.
//

import Foundation
import StoreKit

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            requestReview(in: scene)
        }
    }
}
