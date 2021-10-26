//
//  HapticGenerator.swift
//  Outrank
//
//  Created by Ryan Token on 10/18/21.
//

import Foundation
import SwiftUI

class HapticGenerator {
    static func playSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func playWarningHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    static func playErrorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
