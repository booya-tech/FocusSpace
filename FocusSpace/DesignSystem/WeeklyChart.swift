//
//  WeeklyChart.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/3/25.
//
//  Simple bar chart for weekly session data
//

import SwiftUI

/// Simple bar chart showing weekly focus session minutes
struct WeeklyChart: View {
    let data: [DayData]
    let maxHeight: CGFloat = 60

    private var maxMinutes: Int {
        data.map(\.minutes).max() ?? 1
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("This Week")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText)

            HStack(alignment: .bottom, spacing: 4) {
                ForEach(data) { dayData in
                    VStack(spacing: 4) {
                        // Bar
                        RoundedRectangle(cornerRadius: 3)
                            .fill(dayData.minutes > 0 ? AppColors.primaryText : AppColors.secondaryBackground)
                            .frame(
                                width: 24,
                                height: max(4, CGFloat(dayData.minutes) / CGFloat(maxMinutes) * maxHeight)
                            )
                            .animation(.easeIn(duration: 0.2), value: dayData.minutes)

                        // Day label
                        Text(dayData.day)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
        }
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
    WeeklyChart(data: [
        DayData(day: "Mon", minutes: 45, date: Date()),
        DayData(day: "Tue", minutes: 60, date: Date()),
        DayData(day: "Wed", minutes: 30, date: Date()),
        DayData(day: "Thu", minutes: 75, date: Date()),
        DayData(day: "Fri", minutes: 0, date: Date()),
        DayData(day: "Sat", minutes: 80, date: Date()),
        DayData(day: "Sun", minutes: 60, date: Date()),
    ])
}
