//
//  EmptyStateView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/20/25.
//
//  Empty state display component
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(AppColors.accent.opacity(0.6))
            
            // Text
            VStack(spacing: 8) {
                Text(title)
                    .font(AppTypography.title)
                    .foregroundColor(AppColors.primaryText)
                
                Text(message)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            
            // Optional Action Button
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(title: actionTitle) {
                    action()
                }
                .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        EmptyStateView(
            icon: "timer",
            title: "No Sessions Yet",
            message: "Start your first focus session to see your stats",
            actionTitle: "Start Focus",
            action: { print("Start tapped") }
        )
        
        Divider()
        
        EmptyStateView(
            icon: "checkmark.circle",
            title: "All Done!",
            message: "You've completed all your tasks for today"
        )
    }
}
