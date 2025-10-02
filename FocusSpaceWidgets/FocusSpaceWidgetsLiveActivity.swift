//
//  FocusSpaceWidgetsLiveActivity.swift
//  FocusSpaceWidgets
//
//  Created by Panachai Sulsaksakul on 9/14/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FocusSpaceWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock screen/banner UI
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            // Dynamic Island UI
            DynamicIsland {
                // Expanded UI (when user long presses or gets update)
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(context.state.sessionType.color)
                            .frame(width: 8, height: 8)
                        Text(context.state.sessionType.displayName)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.timeDisplay)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .monospacedDigit()
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        ProgressView(value: context.state.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: context.state.sessionType.color))
                        Image(systemName: context.state.isRunning ? "pause.fill" : "play.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                }
            } compactLeading: {
                // Compact leading (left side of notch) - main timer display
                Circle()
                    .fill(context.state.sessionType.color)
                    .frame(width: 12, height: 12)
            } compactTrailing: {
                // Compact trailing (right side of notch) - time display
                Text(timerInterval: Date()...context.state.endTime, countsDown: true)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .monospacedDigit()
            } minimal: {
                // Minimal state (when another activity takes priority)
                Circle()
                    .fill(context.state.sessionType.color)
                    .frame(width: 12, height: 12)
            }
        }
    }
}

// MARK: - Preview
#Preview("Live Activity", as: .content, using: TimerActivityAttributes(
    presetName: "25 min",
    startedAt: Date()
)) {
    FocusSpaceWidgetsLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState(
        sessionType: .focus,
        totalSeconds: 1500,
        isRunning: true,
        endTime: Date().addingTimeInterval(900)
    )
    
    TimerActivityAttributes.ContentState(
        sessionType: .shortBreak,
        totalSeconds: 300,
        isRunning: false,
        endTime: Date().addingTimeInterval(120)
    )
}
