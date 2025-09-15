//
//  TimerActivityAttributes.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/14/25.
//

import Foundation
import ActivityKit

struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic properties (updated during timer)
        var sessionType: SessionType
        var totalSeconds: Int
        var remainingSeconds: Int
        var isRunning: Bool
        var endTime: Date
        
        // Computed properties
        var progress: Double {
            guard totalSeconds > 0 else { return 0.0 }
            return Double(totalSeconds - remainingSeconds) / Double(totalSeconds)
        }
        
        var timeDisplay: String {
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    // Static properties (don't change during activity)
    let presetName: String
    let startedAt: Date
}
