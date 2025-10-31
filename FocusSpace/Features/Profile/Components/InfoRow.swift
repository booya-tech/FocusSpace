//
//  InfoRow.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/19/25.
//
//  Reusable info row component for app information
//

import SwiftUI

struct InfoRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.body)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if !icon.isEmpty {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(AppColors.primary)
            }
            Text(value)
                .font(AppTypography.body)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding()
    }
}

#Preview {
    VStack(spacing: 0) {
        InfoRow(title: "Version", value: "1.0", icon: "chevron.right")
        Divider()
        InfoRow(title: "Build", value: "", icon: "chevron.right")
    }
}
