//
//  AuthViewModel.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/24/25.
//
//  ViewModel for authentication screen
//

import Foundation

// ViewModel handling authentication UI logic and validation
@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isSignUpMode: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    // Toggle between sign in and sign up modes
    func toggleMode() {
        isSignUpMode.toggle()
        clearForm()
    }

    // Clear form fields and errors
    private func clearForm() {
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = ""
    }

    // Validate form inputs
    private func validateForm() -> Bool {
        errorMessage = ""

        guard !email.isEmpty else { 
            errorMessage = "Email is required"

            return false 
        }

        guard email.contains("@") && email.contains(".") else { 
            errorMessage = "Please enter a valid email"

            return false    
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"

            return false
        }

        if isSignUpMode {
            guard password == confirmPassword else {
                errorMessage = "Passwords don't match"

                return false
            }
        }

        return true
    }

    // Handle sign in or sign up action
    func authenticate() async {
        guard validateForm() else { return }

        isLoading = true
        errorMessage = ""

        defer { isLoading = false }

        do {
            if isSignUpMode {
                try await authService.signUp(
                    email: email,
                    password: password
                )
            } else {
                try await authService.signIn(
                    email: email,
                    password: password
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
