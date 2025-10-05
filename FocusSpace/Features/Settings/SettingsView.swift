//
//  SettingsView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/21/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var preferences = AppPreferences.shared

    var body: some View {
        List {
            Section("Timer Settings") {
                // Custom Focus Durations
                NavigationLink {
                    CustomDurationsView(
                        title: "Focus Durations",
                        durations: $preferences.customFocusDurations,
                        range: 5...120
                    )
                } label: {
                    SettingsRow(
                        icon: "timer",
                        title: "Focus Durations",
                        subtitle: "\(preferences.customFocusDurations.count) presets"
                    )
                }
                // Custom Break Durations
                NavigationLink {
                    BreakDurationPickerView(
                        selectedDuration: $preferences.selectedBreakDuration
                    )
                } label: {
                    SettingsRow(
                        icon: "pause.circle",
                        title: "Break Durations",
                        subtitle: "\(preferences.selectedBreakDuration) presets"
                    )
                }
                
                // Strict Mode Toggle
                HStack {
                    SettingsRow(
                        icon: "lock.circle",
                        title: "Strict Mode",
                        subtitle: "Disable pause/resume"
                    )
                    Spacer()
                    Toggle("", isOn: $preferences.isStrictModeEnabled)
                        .labelsHidden()
                }
            }
            // MARK: - Goal & Tracking
            Section("Goal & Tracking") {
                // Daily Focus Goal
                NavigationLink {
                    DailyGoalView(goalMinutes: $preferences.dailyFocusGoal)
                } label: {
                    SettingsRow(
                        icon: "target",
                        title: "Daily Focus Goal",
                        subtitle: "\(preferences.dailyFocusGoal) minutes"
                    )
                }
            }
            
            // MARK: - Audio & Haptics
            Section("Audio & Haptics") {
                // Sound Toggle
                HStack {
                    SettingsRow(
                        icon: "speaker.wave.2",
                        title: "Completion Sounds",
                        subtitle: "Play sound when timer ends"
                    )
                    Spacer()
                    Toggle("", isOn: $preferences.isSoundEnabled)
                        .labelsHidden()
                }
                // Haptics Toggle
                HStack {
                    SettingsRow(
                        icon: "iphone.radiowaves.left.and.right",
                        title: "Haptic Feedback",
                        subtitle: "Vibrate on timer events"
                    )
                    Spacer()
                    Toggle("", isOn: $preferences.isHapticsEnabled)
                        .labelsHidden()
                }
            }
            
            // MARK: - Reset
            Section("Reset") {
                Button {
                    preferences.resetToDefaults()
                    HapticManager.shared.light()
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.red)
                        Text("Reset to Defaults")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
