//
//  DailyGoalView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/21/25.
//
//  Daily focus goal setting
//

import SwiftUI

// Set daily focus goals with quick select + custom stepper
struct DailyGoalView: View {
    @Binding var goalMinutes: Int
    @Environment(\.dismiss) private var dismiss

    private let goalOptions = [30, 60, 90, 120, 150, 180, 240, 300, 360, 480]

    var body: some View {
        List  {
            Section {
                VStack(spacing: 16) {
                    Text("Daily Focus Goal")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.primaryText)

                    Text("\(goalMinutes) minutes")
                        .font(AppTypography.largeTitle)
                        .foregroundColor(AppColors.accent)
                        .fontWeight(.bold)

                    Text("\(goalMinutes / 60)h \(goalMinutes % 60)m")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section {
                ForEach(goalOptions, id: \.self) { option in
                    Button {
                        goalMinutes = option
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(option) minutes")
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.primaryText)

                                Text("\(option / 60)h \(option % 60)m")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.secondaryText)
                            }

                            Spacer()

                            if goalMinutes == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppColors.accent)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text("Quick Select")
            } footer: {
                Text("Choose a realistic daily focus goal. You can always adjust it later.")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.secondaryText)
            }

            Section {
                HStack {
                    Text("Custom Goal")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.primaryText)

                    Spacer()

                    Stepper(
                        value: $goalMinutes,
                        in: 15...600,
                        step: 15
                    ) {
                        Text("\(goalMinutes) min")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.accent)
                    }
                    .onChange(of: goalMinutes) {
                        HapticManager.shared.light()
                    }
                }
            } footer: {
                Text("Set a custom goal between 15 minutes and 10 hours.")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .navigationTitle("Daily Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .font(AppTypography.body)
            }
        }
    }
}

#Preview {
    DailyGoalView(goalMinutes: .constant(120))
}
