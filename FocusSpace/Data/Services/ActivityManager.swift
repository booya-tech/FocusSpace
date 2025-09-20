//
//  ActivityManager.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/14/25.
//  Manages Live Activity lifecycle for timer sessions
//

import Foundation
import ActivityKit
import SwiftUI

@MainActor
final class ActivityManager: ObservableObject {
    static let shared = ActivityManager()
    
    @Published private(set) var currentActivity: Activity<TimerActivityAttributes>?
    @Published private(set) var activityToken: String?
    @Published private(set) var isActivityRunning: Bool = false
    
    private var activityUpdateTask: Task<Void, Never>?
    
    private init() {}
    
    // MARK: - Live Activity Management
    
    /// Start a new Live Activity for timer session
    func startNewLiveActivity(
        presetName: String,
        sessionType: SessionType,
        totalSeconds: Int,
        remainingSeconds: Int,
        isRunning: Bool
    ) async {
        // End existing activity if running
        await endLiveActivity()
        
        // Check if Live Activities are supported
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not enabled")
            return
        }
        
        // Create attributes (static data)
        let attributes = TimerActivityAttributes(
            presetName: presetName,
            startedAt: Date()
        )
        
        // Create content state (dynamic data)
        let contentState = TimerActivityAttributes.ContentState(
            sessionType: sessionType,
            totalSeconds: totalSeconds,
            isRunning: isRunning,
            endTime: Date().addingTimeInterval(TimeInterval(remainingSeconds))
        )
        
        do {
            // Request Live Activity
            let activity = try Activity<TimerActivityAttributes>.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: nil)
            )
            
            // Store activity reference
            currentActivity = activity
            isActivityRunning = true
            
            // Get push token for remote updates (optional)
            if let pushToken = activity.pushToken {
                activityToken = pushToken.hexString
                print("📱 Activity push token: \(activityToken ?? "nil")")
            }
            
            print("Live Activity started successfully")
            
            // Start periodic updates
            startActivityUpdates()
            
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }
    
    /// Update existing Live Activity with new timer state
    func updateLiveActivity(
        sessionType: SessionType,
        totalSeconds: Int,
        remainingSeconds: Int,
        isRunning: Bool
    ) async {
        guard let activity = currentActivity else {
            return
        }
        
        let contentState = TimerActivityAttributes.ContentState(
            sessionType: sessionType,
            totalSeconds: totalSeconds,
            isRunning: isRunning,
            endTime: Date().addingTimeInterval(TimeInterval(remainingSeconds))
        )
        
        do {
            await activity.update(.init(state: contentState, staleDate: nil))
            print("Live Activity updated")
        } catch {
            print("Failed to update Live Activity: \(error)" )
        }
    }
    
    /// End Live Activity with completion state
    func endLiveActivity(with finalState: TimerActivityAttributes.ContentState? = nil) async {
        // Cancel update task
        activityUpdateTask?.cancel()
        activityUpdateTask = nil
        
        guard let activity = currentActivity else {
            print("⚠️ No active Live Activity to end")
            return
        }
        
        do {
            if let finalState = finalState {
                // Show final state for 5 seconds before dismissing
                await activity.end(
                    .init(state: finalState, staleDate: nil),
                    dismissalPolicy: .after(Date().addingTimeInterval(5))
                )
                print("✅ Live Activity ended with final state")
            } else {
                // End immediately
                await activity.end(nil, dismissalPolicy: .immediate)
                print("✅ Live Activity ended immediately")
            }
        } catch {
            print("❌ Failed to end Live Activity: \(error)")
        }
        
        // Clean up state
        currentActivity = nil
        activityToken = nil
        isActivityRunning = false
    }
    
    // MARK: - Private Methods
    
    /// Start periodic updates for Live Activity
    private func startActivityUpdates() {
        activityUpdateTask?.cancel()
        
        activityUpdateTask = Task {
            while !Task.isCancelled && currentActivity != nil && isActivityRunning {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                // Update logic can be added here if needed
            }
        }
    }
}

// MARK: - Data Extensions

extension Data {
    /// Convert push token data to hex string
    var hexString: String {
        map { String(format: "%02.2hhx", $0) }.joined()
    }
}
