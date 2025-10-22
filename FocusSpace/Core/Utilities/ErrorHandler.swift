//
//  ErrorHandler.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/20/25.
//
//  Centralized error handling and logging
//

import Foundation
import SwiftUI

@MainActor
final class ErrorHandler: ObservableObject {
    static let shared = ErrorHandler()
    
    @Published var currentError: AppError?
    @Published var showErrorAlert = false
    @Published var toastMessage: String?
    
    private init() {}
    
    /// Handle an error with optional custom message
    func handle(_ error: Error, customMessage: String? = nil) {
        let appError = AppError.from(error)
        
        // Log the error
        Logger.log("❌ Error: \(appError.localizedDescription)")
        if let recovery = appError.recoverySuggestion {
            Logger.log("💡 Suggestion: \(recovery)")
        }
        
        // Only show user-facing errors
        guard appError.shouldDisplay else { return }
        
        // Use custom message if provided
        if let customMessage = customMessage {
            showToast(customMessage)
        } else {
            currentError = appError
            showErrorAlert = true
        }
    }
    
    /// Show a temporary toast message
    func showToast(_ message: String, duration: TimeInterval = 3.0) {
        toastMessage = message
        
        Task {
            try? await Task.sleep(for: .seconds(duration))
            await MainActor.run {
                if self.toastMessage == message {
                    self.toastMessage = nil
                }
            }
        }
    }
    
    /// Show success message
    func showSuccess(_ message: String) {
        showToast(message)
    }
    
    /// Clear current error
    func clearError() {
        currentError = nil
        showErrorAlert = false
    }
}

// MARK: - View Extension for Error Handling
extension View {
    /// Add error alert modifier
    func errorAlert(errorHandler: ErrorHandler = .shared) -> some View {
        self.alert(
            "Error",
            isPresented: Binding(
                get: { errorHandler.showErrorAlert },
                set: { if !$0 { errorHandler.clearError() } }
            ),
            presenting: errorHandler.currentError
        ) { error in
            Button("OK", role: .cancel) {
                errorHandler.clearError()
            }
        } message: { error in
            VStack(spacing: 8) {
                if let description = error.errorDescription {
                    Text(description)
                }
                if let suggestion = error.recoverySuggestion {
                    Text(suggestion)
                        .font(.caption)
                }
            }
        }
    }
    
    /// Add toast overlay
    func toast(errorHandler: ErrorHandler = .shared) -> some View {
        self.overlay(alignment: .top) {
            if let message = errorHandler.toastMessage {
                ToastView(message: message)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(), value: errorHandler.toastMessage)
            }
        }
    }
}
