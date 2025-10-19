//
//  StatRow.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/19/25.
//
//  Reusable stat row component for profile stats
//

import SwiftUI

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppColors.primary)
                .frame(width: 32)
            
            Text(title)
                .font(AppTypography.body)
                .foregroundColor(AppColors.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(AppTypography.body)
                .fontWeight(.medium)
                .foregroundColor(AppColors.primaryText)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        StatRow(
            icon: "checkmark.circle.fill",
            title: "Total Sessions",
            value: "42"
        )
        
        StatRow(
            icon: "clock.fill",
            title: "Total Focus Time",
            value: "1,050 min"
        )
        
        StatRow(
            icon: "flame.fill",
            title: "Current Streak",
            value: "7 days"
        )
    }
    .padding()
}