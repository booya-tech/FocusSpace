//
//  AppViewModel.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/23/25.
//

import SwiftUI
import Combine

@MainActor
final class AppViewModel: NSObject,ObservableObject {
    @Published var authService = AuthService()
    @Published var notificationManager = NotificationManager.shared
    @Published var isLoading = true

    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

        authService.$currentUser
            .sink { [weak self] user in
                self?.objectWillChange.send()

                if user != nil {
                    Task {
                        await self?.requestNotificationPermissions()
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        await MainActor.run {
                            self?.isLoading = false
                        }
                    }
                } else {
                    Task { @MainActor in
                        // No user, loading complete
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        self?.isLoading = false
                    }
                }
            }
            .store(in: &cancellables)
    }

    var isAuthenticated: Bool {
        authService.currentUser != nil
    }

    func signOut() async {
        do {
            try await authService.signOut()
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }

    // Add notification permission request
    private func requestNotificationPermissions() async {
        await notificationManager.requestPermission()
    }
}
