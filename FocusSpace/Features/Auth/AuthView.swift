//
//  AuthView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/24/25.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel

    init(authService: AuthService) {
        self._viewModel = StateObject(wrappedValue: AuthViewModel(authService: authService))
    }

    var body: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 8) {
                Text("FocusSpace")
                    .font(AppTypography.title1)
                    .foregroundColor(AppColors.primaryText)

                Text(viewModel.isSignUpMode ? "Create an account" : "Welcome back")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.secondaryText)
            }

            // Form
            VStack(spacing: 16) {
                // Email field
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                // Password field
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Confirm password (only for sign up)
                if viewModel.isSignUpMode {
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                // Error message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(AppTypography.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            
            
            // Action buttons
            VStack(spacing: 16) {
                // Main action button
                PrimaryButton(
                    title: viewModel.isLoading ? "Loading..." : (viewModel.isSignUpMode ? "Sign Up" : "Sign In")
                ) {
                    Task {
                        await viewModel.authenticate()
                    }
                }
                .disabled(viewModel.isLoading)

                Button(action: viewModel.toggleMode) {
                    Text(viewModel.isSignUpMode ? "Already have an account? Sign In" : "Don't have an account?  Sign Up")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview {
    AuthView(authService: AuthService())
}
