//
//  NotificationManager.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/19/25.
//
//  Local notification management for timer completion
//

import Foundation
import UserNotifications
import UIKit

/// Manages local notifications for timer events
@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published private(set) var isAuthorized = false
    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private let notificationCenter = UNUserNotificationCenter.current()

    private init() {
        Task {
            await checkAuthorizationStatus()
        }
    }

    // Request notification permissions from user
    func requestPermission() async {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])

            await checkAuthorizationStatus()

            if granted {
                print("✅ Notification permission granted")
            } else {
                print("❌ Notification permission denied")
            }
        } catch {
            print("❌ Failed to request notification permission: \(error)")
        }
    }

    private func checkAuthorizationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        authorizationStatus = settings.authorizationStatus
        isAuthorized = authorizationStatus == .authorized
    }

    // MARK: - Notification Scheduling
    
    /// Schedule notification for timer completion
    func scheduleTimerCompletion(
        for sessionType: SessionType,
        in seconds: TimeInterval,
        presetName: String
    ) async {
        guard isAuthorized else {
            print("⚠️ Notifications not authorized")
            return
        }
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = sessionType.notificationTitle
        content.body = sessionType.notificationBody(presetName: presetName)
        content.sound = .default
        content.badge = 1
        
        // Create trigger for specified time
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: seconds,
            repeats: false
        )
        
        // Create request with unique identifier
        let identifier = "timer_\(sessionType.rawValue)_\(Date().timeIntervalSince1970)"
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        do {
            try await notificationCenter.add(request)
            print("📱 Scheduled notification for \(sessionType.displayName) in \(Int(seconds))s")
        } catch {
            print("❌ Failed to schedule notification: \(error)")
        }
    }

    /// Cancel all pending timer notifications
    func cancelAllTimerNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        print("🗑️ Cancelled all pending notifications")
    }

    /// Cancel specific timer notification
    func cancelTimerNotification(for sessionType: SessionType) {
        let identifiers = ["timer_\(sessionType.rawValue)"]
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        print("🗑️ Cancelled \(sessionType.displayName) notification")
    }

    //MARK: - Debugging Methods
    // Add this method to NotificationManager class
    func debugPendingNotifications() async {
        let requests = await notificationCenter.pendingNotificationRequests()
        print("🔍 Pending Notifications: \(requests.count)")
        for request in requests {
            print("   ID: \(request.identifier)")
            if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                print("   Time Interval: \(trigger.timeInterval)s")
            }
        }
    }

    // Add this method to NotificationManager class
    func debugAuthorizationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        print("🔍 Notification Debug:")
        print("   Authorization Status: \(settings.authorizationStatus.rawValue)")
        print("   Alert Setting: \(settings.alertSetting.rawValue)")
        print("   Sound Setting: \(settings.soundSetting.rawValue)")
        print("   Badge Setting: \(settings.badgeSetting.rawValue)")
        print("   isAuthorized: \(isAuthorized)")
    }
}

extension SessionType {
    var notificationTitle: String {
        switch self {
            case .focus: return "Focus Session Completed!"
            case .shortBreak: return "Break Time Over!"
            case .longBreak: return "Break Time Over!"
        }
    }

    func notificationBody(presetName: String) -> String {
        switch self {
        case .focus:
            return "Great work! Your \(presetName)-minute focus session is done. Time for a break!"
        case .shortBreak:
            return "Ready to get back to work? Your break is over."
        case .longBreak:
            return "Refreshed and ready! Time to start your next focus session."
        }
    }
}
