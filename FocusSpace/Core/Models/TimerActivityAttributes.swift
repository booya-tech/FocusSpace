//
//  TimerActivityAttributes.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/14/25.
//

import Foundation
import ActivityKit

struct TimerActivityAttributes: ActivityAttributes {
    // Static properties (don't change during activity)
    let presetName: String
    let startedAt: Date

    public struct ContentState: Codable, Hashable {
        // Dynamic properties (updated during timer)
        var sessionType: SessionType // focus -> short break -> etc.
        var totalSeconds: Int // 1500, 300, etc.
        var isRunning: Bool // true/false (play/pause)
        var endTime: Date // when timer will finish
        
        // Computed properties
        var progress: Double {
            guard totalSeconds > 0 else { return 0.0 }
            let elapsed = Date().timeIntervalSince(startTime)
            return min(elapsed / Double(totalSeconds), 1.0)
        }

        private var startTime: Date {
            endTime.addingTimeInterval(-Double(totalSeconds))
        }
        
        var timeDisplay: String {
            let remaining = max(0, Int(endTime.timeIntervalSince(Date())))
            let minutes = remaining / 60
            let seconds = remaining % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
