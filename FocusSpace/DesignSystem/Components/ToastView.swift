//
//  ToastView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/20/25.
//
//  Toast notification component
//

import SwiftUI

struct ToastView: View {
    let message: String
    let type: ToastType
    
    init(message: String, type: ToastType = .info) {
        self.message = message
        self.type = type
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.icon)
                .foregroundColor(type.iconColor)
                .font(.title3)
            
            Text(message)
                .font(AppTypography.body)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(type.borderColor, lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

// MARK: - Toast Types
enum ToastType {
    case success
    case error
    case warning
    case info
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return AppColors.accent
        }
    }
    
    var borderColor: Color {
        switch self {
        case .success: return .green.opacity(0.3)
        case .error: return .red.opacity(0.3)
        case .warning: return .orange.opacity(0.3)
        case .info: return AppColors.accent.opacity(0.3)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        ToastView(message: "Session completed!", type: .success)
        ToastView(message: "Failed to sync", type: .error)
        ToastView(message: "Timer already running", type: .warning)
        ToastView(message: "Syncing your data...", type: .info)
    }
    .padding()
    .background(AppColors.background)
}
