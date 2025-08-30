//
//  AuthService.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/24/25.
//
//  Authentication service for email/password sign-in
//

import Foundation
import Supabase
import Auth

@MainActor
final class AuthService: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var isLoading = false

    private let supabase = SupabaseManager.shared.client

    init() {
        // Check for existing session on app launch
        Task {
            await checkCurrentSession()
        }
    }

    // Check if user has an existing session
    private func checkCurrentSession() async {
        do {
            let session = try await supabase.auth.session
            currentUser = session.user
        } catch {
            print("No exisiting session found")
            currentUser = nil
        }
    }

    // Sign up with email and password
    func signUp(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }

        let response = try await supabase.auth.signUp(
            email: email,
            password: password
        )

        currentUser = response.user
    }

    // Sign in with email and password
    func signIn(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }

        let response = try await supabase.auth.signIn(
            email: email,
            password: password
        )

        currentUser = response.user
    }

    // Sign out current user
    func signOut() async throws {
        isLoading = true
        defer { isLoading = false }

        try await supabase.auth.signOut()
        currentUser = nil
    }

    // Check if user is authenticated
    var isAuthenticated: Bool {
        currentUser != nil
    }
}
