//
//  TimerViewModel.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/30/25.
//
//  Timer state management and core logic
//

import Foundation
import SwiftUI
import UIKit

/// Timer state for the state machine
enum TimerState {
    case idle // Timer not started
    case running // Timer actively counting down
    case paused // Timer paused
    case completed // Timer finished
}

@MainActor
final class TimerViewModel: ObservableObject {
    // Published properties
    @Published var remainingSeconds: Int = 0
    @Published var totalSeconds: Int = 0
    @Published var currentState: TimerState = .idle
    @Published var currentSessionType: SessionType = .focus
    @Published var selectedPreset: TimerPreset = TimerPreset.defaults[0]
    @Published var completedSessions: [Session] = []

    // Computed properties
    var isRunning: Bool { currentState == .running }
    var isPaused: Bool { currentState == .paused }
    var isIdle: Bool { currentState == .idle }
    var isCompleted: Bool { currentState == .completed }

    // Formatted time display (MM:SS)
    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Progress percentage (0.0 - 1.0)
    var progress: Double {
        guard totalSeconds > 0 else { return 0.0 }

        return Double(totalSeconds - remainingSeconds) / Double(totalSeconds)
    }

    private var timer: Timer?
    private var sessionStartTime: Date?

    // MARK: - Timer Actions
    // Start a new timer session
    func start(preset: TimerPreset, sessionType: SessionType = .focus) {
        stop() // Clear any existing timer

        selectedPreset = preset
        currentSessionType = sessionType
        totalSeconds = preset.minutes * 60
        remainingSeconds = totalSeconds
        sessionStartTime = Date()
        currentState = .running

        startTimer()

        // Add haptic feedback
        HapticManager.shared.light()
    }

    // Pause the current timer
    func pause() {
        guard currentState == .running else { return }

        currentState = .paused
        stopTimer()

        // Add haptic feedback
        HapticManager.shared.light()
    }

    // Resume the paused timer
    func resume() {
        guard currentState == .paused else { return }

        currentState = .running
        startTimer()

        // Add haptic feedback
        HapticManager.shared.medium()
    }

    // Stop and reset the timer
    func stop() {
        currentState = .idle
        stopTimer()
        remainingSeconds = 0
        totalSeconds = 0
        sessionStartTime = nil

        // Add haptic feedback
        HapticManager.shared.warning()
    }

    // Skip to break (when in focus session)
    func skipToBreak() {
        guard currentSessionType == .focus else { return }

        // Save the incomplete session if desired
        completeCurrentSession()

        // Start short break
        let breakDuration = SessionType.shortBreak.defaultMinutes
        let breakPreset = TimerPreset(durationTitle: "\(breakDuration)", minutes: breakDuration)
        start(preset: breakPreset, sessionType: .shortBreak)
    }

    // Skip the current break
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
            Task { @MainActor in
                self.timerTick()
            }
        }
    }

    private func timerTick() {
        guard remainingSeconds > 0 else {
            timerCompleted()
            return
        }

        remainingSeconds -= 1
    }

    private func timerCompleted() {
        currentState = .completed
        stopTimer()

        // Add haptic feedback
        HapticManager.shared.success()

        // Save completed session
        completeCurrentSession()

        // Auto-transition to break or notify completion
        autoTransition()
    }

    private func completeCurrentSession() {
        guard let startTime = sessionStartTime else { return }

        let session = Session(
            type: currentSessionType,
            startAt: startTime,
            endAt: Date(),
            tag: nil
        )

        completedSessions.append(session)
    }

    private func autoTransition() {
        // Auto-start break after focus session
        if currentSessionType == .focus {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let breakDuration = SessionType.shortBreak.defaultMinutes
                let breakPreset = TimerPreset(durationTitle: "\(breakDuration)", minutes: breakDuration)

                self.start(preset: breakPreset, sessionType: .shortBreak)
            }
        } 
        // After break, return to idle state
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.stop()
            }
        }
    }
}