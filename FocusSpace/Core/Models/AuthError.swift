//
//  AuthError.swift
//  MonoTimer
//
//  Created by Panachai Sulsaksakul on 10/30/25.
//

import Foundation

enum AuthError: LocalizedError {
    case notAuthenticated
    case invalidPassword
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated: return "Not authenticated"
        case .invalidPassword: return "Invalid password"
        }
    }
}
