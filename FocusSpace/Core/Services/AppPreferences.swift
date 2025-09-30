//
//  AppPreferences.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/21/25.
//
//  User preferences and settings management
//

import Foundation
import SwiftUI

@MainActor
final class AppPreferences: ObservableObject {
    static let shared = AppPreferences()

    private let defaults = UserDefaults.standard

    // MARK: - Timer Settings
    // Custom focus durations (in minutes)
    @Published var customFocusDurations: [Int] {
        didSet { defaults.set(customFocusDurations, forKey: "customFocusDurations") }
    }
    // Custom break durations (in minutes)
    @Published var customBreakDurations: [Int] {
        didSet { defaults.set(customBreakDurations, forKey: "customBreakDurations") }
    }
    // Strict mode (disable pause/resume)
    @Published var isStrictModeEnabled: Bool {
        didSet { defaults.set(isStrictModeEnabled, forKey: "isStrictModeEnabled") }
    }

    // MARK: - Goal & Tracking
    @Published var dailyFocusGoal: Int {
        didSet { defaults.set(dailyFocusGoal, forKey: "dailyFocusGoal")}
    }

    // MARK: - Audio & Haptics
    // Enable completion sounds
    @Published var isSoundEnabled: Bool {
        didSet { defaults.set(isSoundEnabled, forKey: "isSoundEnabled") }
    }
    // Enable haptic feedback
    @Published var isHapticsEnabled: Bool {
        didSet { defaults.set(isHapticsEnabled, forKey: "isHapticsEnabled") }
    }

    // MARK: - Initialization
    private init() {
        self.customFocusDurations = defaults.object(forKey: "customFocusDurations") as? [Int] ?? [25, 30, 35, 40, 45, 50]
        self.customBreakDurations = defaults.object(forKey: "customBreakDurations") as? [Int] ?? [5, 10]
        self.isStrictModeEnabled = defaults.bool(forKey: "isStrictModeEnabled")
        self.dailyFocusGoal = defaults.object(forKey: "dailyFocusGoal") as? Int ?? 120
        self.isSoundEnabled = defaults.object(forKey: "isSoundEnabled") as? Bool ?? true
        self.isHapticsEnabled = defaults.object(forKey: "isHapticsEnabled") as? Bool ?? true
    }

    // MARK: - Helper Methods
    // Get timer presets based on current settings
    var currentTimerPresets: [TimerPreset] {
        return customFocusDurations.map { minutes in
            TimerPreset(durationTitle: "\(minutes)", minutes: minutes)
        }
    }

    // Reset all preferences to defaults
    func resetToDefaults() {
        customFocusDurations = [25, 30, 35, 40, 45, 50]
        customBreakDurations = [5, 10]
        isStrictModeEnabled = false
        dailyFocusGoal = 120
        isSoundEnabled = true
        isHapticsEnabled = true
    }
}


