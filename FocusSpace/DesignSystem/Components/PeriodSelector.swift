//
//  PeriodSelector.swift
//  MonoTimer
//
//  Created by Panachai Sulsaksakul on 11/1/25.
//

import SwiftUI

struct PeriodSelector: View {
    @Binding var selectedPeriod: TimePeriod
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TimePeriod.allCases) { period in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedPeriod = period
                    }
                }) {
                    periodButton(for: period)
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.background)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.secondaryText.opacity(0.2), lineWidth: 1)
                }
        )
    }
    
    private func periodButton(for period: TimePeriod) -> some View {
        let isSelected = selectedPeriod == period
        
        return Text(period.rawValue)
            .font(AppTypography.caption)
            .fontWeight(isSelected ? .semibold : .regular)
            .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(isSelected ? AppColors.secondaryBackground : Color.clear)
            .cornerRadius(8)
    }
}

#Preview {
    @Previewable @State var period: TimePeriod = .week
    return PeriodSelector(selectedPeriod: $period)
        .padding()
}
