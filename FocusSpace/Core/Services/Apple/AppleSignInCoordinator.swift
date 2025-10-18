//
//  AppleSignInCoordinator.swift
//  FocusSpace
//
//  Coordinator to handle Apple Sign In delegate callbacks
//  Created by Panachai Sulsaksakul on 10/16/25.
//

import Foundation
import AuthenticationServices
import UIKit

/// Helper class that bridges Apple's delegate pattern to Swift's async/await
@MainActor
final class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private let continuation: CheckedContinuation<ASAuthorization, Error>
    
    init(continuation: CheckedContinuation<ASAuthorization, Error>) {
        self.continuation = continuation
        super.init()
    }
    
    // Called when authorization succeeds
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        continuation.resume(returning: authorization)
    }
    
    // Called when authorization fails
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation.resume(throwing: error)
    }
    
    // Provides the window for presenting the Apple sign-in sheet
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window
    }
}
