//
//  TimerControlsView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/31/25.
//

import SwiftUI

struct TimerControlsView: View {
    @ObservedObject var timerViewModel: TimerViewModel

    var body: some View {
        HStack(spacing: 16) {
            if timerViewModel.isIdle {
                PrimaryButton(title: "Start Focus") {
                    timerViewModel.start(preset: timerViewModel.selectedPreset)
                }
            } else if timerViewModel.isRunning {
                PrimaryButton(title: "Pause") {
                    timerViewModel.pause()
                }

                if timerViewModel.currentSessionType == .focus {
                    PrimaryButton(title: "Skip to Break", isDestructive: true) {
                        timerViewModel.skipToBreak()
                    }
                }
            } else if timerViewModel.isPaused {
                PrimaryButton(title: "Resume") {
                    timerViewModel.resume()
                }

                PrimaryButton(title: "Stop", isDestructive: true) {
                    timerViewModel.stop()
                }
            }
        }
    }
}

#Preview {
    TimerControlsView(timerViewModel: TimerViewModel())
}
