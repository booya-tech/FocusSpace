//
//  TimerPreset.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/23/25.
//
//  Timer preset model for predefined focus durations
//

import Foundation

/// Predifined timer durations for focus sessions
struct TimerPreset: Identifiable, Hashable {
    let id = UUID()
    let durationTitle: String
    let minutes: Int

    /// Default presets for the app
    static let defaults: [TimerPreset] = [
        TimerPreset(durationTitle: "1", minutes: 1),
        TimerPreset(durationTitle: "30", minutes: 30),
        TimerPreset(durationTitle: "35", minutes: 35),
        TimerPreset(durationTitle: "40", minutes: 40),
        TimerPreset(durationTitle: "45", minutes: 45),
        TimerPreset(durationTitle: "50", minutes: 50)
    ]
}
