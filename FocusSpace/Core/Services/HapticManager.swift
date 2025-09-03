//
//  HapticManager.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/31/25.
//
//  Haptic feedback management for timer events
//

import UIKit

// Manages haptic feedback for timer events
final class HapticManager {
    static let shared = HapticManager()

    private init() {}

    // Light haptic for button taps and selections
    func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    // Medium haptic for timer start/pause/resume
    func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    // Heavy haptic for timer completion
    func heavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    // Success haptic for session completion
    func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    // Warning haptic for destructive actions
    func warning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
}


