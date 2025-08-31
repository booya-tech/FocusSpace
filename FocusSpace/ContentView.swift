//
//  ContentView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/22/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerViewModel = TimerViewModel()

    var body: some View {
        VStack(spacing: 32) {
            // Session type indicator 
            Text(timerViewModel.currentSessionType.displayName)
                .font(AppTypography.title3)
                .foregroundColor(AppColors.secondaryText)

            // Timer display
            VStack(spacing: 8) {
                Text(timerViewModel.formattedTime)
                    .font(AppTypography.timerLarge)
                    .foregroundColor(AppColors.primaryText)
                    .monospacedDigit()

                // Progress indicator
                if !timerViewModel.isIdle {
                    ProgressView(value: timerViewModel.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: AppColors.accent))
                        .frame(width: 200)
                }
            }

            // Preset selection (only when idle)
            if timerViewModel.isIdle {
                PresetSelectionView(selectedPreset: $timerViewModel.selectedPreset, presets: TimerPreset.defaults)
            }

            // Timer controls
            TimerControlsView(timerViewModel: timerViewModel)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview {
    ContentView()
}
