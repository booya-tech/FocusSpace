//
//  StatsCard.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/3/25.
//

import SwiftUI

struct StatsCard: View {
    let title: String
    let value: String
    let subtitle: String?

    init(title: String, value: String, subtitle: String? = nil) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText)

            Text(value)
                .font(AppTypography.title2)
                .foregroundColor(AppColors.primaryText)
                .fontWeight(.medium)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
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
}

#Preview {
    HStack(spacing: 16) {
        StatsCard(title: "Today", value: "45", subtitle: "minutes")
        StatsCard(title: "Today", value: "45")
    }
    .padding()
}
