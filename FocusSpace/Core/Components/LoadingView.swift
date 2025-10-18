//
//  LoadingView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/5/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(AppColors.accent)
            
            Text("Loading...")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

// MARK: - Preview
#Preview {
    LoadingView()
}
