//
//  AppError.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/20/25.
//
//  Type-safe error definitions for the app
//

import Foundation

enum AppError: LocalizedError {
    // MARK: - Authentication Errors
    case authenticationFailed(String)
    case invalidCredentials
    case userCancelled
    case appleSignInFailed
    case tokenInvalid
    case sessionExpired
    
    // MARK: - Network Errors
    case networkUnavailable
    case serverError(Int)
    case timeout
    case invalidResponse
    
    // MARK: - Data Errors
    case syncFailed(String)
    case saveFailed
    case loadFailed
    case dataCorrupted
    
    // MARK: - Timer Errors
    case timerAlreadyRunning
    case timerNotRunning
    case invalidDuration
    
    // MARK: - Permission Errors
    case notificationPermissionDenied
    case liveActivityPermissionDenied
    
    // MARK: - Generic Errors
    case unknown(Error)
    
    // MARK: - LocalizedError Conformance
    var errorDescription: String? {
        switch self {
        // Authentication
        case .authenticationFailed(let message):
            return message
        case .invalidCredentials:
            return "Invalid email or password"
        case .userCancelled:
            return "Sign in was cancelled"
        case .appleSignInFailed:
            return "Unable to sign in with Apple"
        case .tokenInvalid:
            return "Session token is invalid"
        case .sessionExpired:
            return "Your session has expired. Please sign in again"
            
        // Network
        case .networkUnavailable:
            return "No internet connection"
        case .serverError(let code):
            return "Server error (\(code))"
        case .timeout:
            return "Request timed out"
        case .invalidResponse:
            return "Invalid server response"
            
        // Data
        case .syncFailed(let message):
            return "Sync failed: \(message)"
        case .saveFailed:
            return "Failed to save data"
        case .loadFailed:
            return "Failed to load data"
        case .dataCorrupted:
            return "Data is corrupted"
            
        // Timer
        case .timerAlreadyRunning:
            return "Timer is already running"
        case .timerNotRunning:
            return "No active timer"
        case .invalidDuration:
            return "Invalid timer duration"
            
        // Permissions
        case .notificationPermissionDenied:
            return "Notification permission denied"
        case .liveActivityPermissionDenied:
            return "Live Activity permission denied"
            
        // Generic
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkUnavailable:
            return "Check your internet connection and try again"
        case .sessionExpired:
            return "Please sign in again to continue"
        case .notificationPermissionDenied:
            return "Enable notifications in Settings to get timer alerts"
        case .liveActivityPermissionDenied:
            return "Enable Live Activities in Settings"
        case .invalidCredentials:
            return "Please check your email and password"
        case .syncFailed:
            return "Your data will sync when connection is restored"
        default:
            return nil
        }
    }
    
    /// Should this error be shown to the user?
    var shouldDisplay: Bool {
        switch self {
        case .userCancelled:
            return false // Don't show UI for user cancellations
        default:
            return true
        }
    }
    
    /// Is this error recoverable?
    var isRecoverable: Bool {
        switch self {
        case .networkUnavailable, .timeout, .syncFailed:
            return true
        case .sessionExpired, .invalidCredentials:
            return true // User can re-authenticate
        default:
            return false
        }
    }
}

// MARK: - Error Mapping
extension AppError {
    /// Convert generic Error to AppError
    static func from(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        
        // Map common errors
        let nsError = error as NSError
        switch nsError.domain {
        case NSURLErrorDomain:
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
                return .networkUnavailable
            case NSURLErrorTimedOut:
                return .timeout
            default:
                return .unknown(error)
            }
        default:
            return .unknown(error)
        }
    }
}
