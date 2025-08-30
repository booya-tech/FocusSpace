//
//  AppViewModel.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/23/25.
//

import SwiftUI
import Combine

@MainActor
final class AppViewModel: ObservableObject {
    @Published var authService = AuthService()

    private var cancellables = Set<AnyCancellable>()

    init() {
        authService.$currentUser
            .sink { [weak self] _ in
                self?.objectWillChange.send()
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
}