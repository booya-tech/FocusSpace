//
//  DeleteAccountView.swift
//  MonoTimer
//
//  Created by Panachai Sulsaksakul on 10/30/25.
//

import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel: DeleteAccountViewModel
    
    init(authService: AuthService) {
        _viewModel = StateObject(wrappedValue: DeleteAccountViewModel(authService: authService))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Warning Icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .padding(.top, 40)
                
                // Title
                Text("Delete Account")
                    .font(AppTypography.title1)
                    .foregroundColor(AppColors.primaryText)
                
                // Warning Message
                VStack(spacing: 12) {
                    Text("This action is permanent and cannot be undone.")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("All your data will be deleted:")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.secondaryText)
                        .padding(.top, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        DataRow(text: "Focus sessions")
                        DataRow(text: "Statistics and streaks")
                        DataRow(text: "Personal settings")
                        DataRow(text: "Account information")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.secondaryBackground)
                    )
                }
                .padding(.horizontal)
                
                // Password Confirmation
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Your Password")
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.primaryText)
                    
                    SecureField("Enter password", text: $viewModel.password)
                        .textContentType(.password)
                        .autocapitalization(.none)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.secondaryBackground)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.secondaryText.opacity(0.2), lineWidth: 1)
                                }
                        )
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(AppTypography.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Buttons
                VStack(spacing: 8) {
                    // Delete Button
                    Button(action: {
                        Task {
                            await viewModel.deleteAccount()
                        }
                    }) {
                        HStack {
                            if viewModel.isDeleting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Delete My Account")
                                    .font(AppTypography.body)
                                    .fontWeight(.semibold)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red)
                        )
                    }
                    .disabled(viewModel.isDeleting || viewModel.password.isEmpty)
                    .opacity(viewModel.password.isEmpty ? 0.5 : 1.0)
                    
                    // Cancel Button
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.secondaryText.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .disabled(viewModel.isDeleting)
                }
                .padding(.horizontal)
                .padding(.top, 24)
                
                Spacer()
            }
        }
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Supporting Views
private struct DataRow: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .font(.caption)
            Text(text)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

#Preview {
    NavigationStack {
        DeleteAccountView(authService: AuthService())
            .environmentObject(AuthService())
    }
}
