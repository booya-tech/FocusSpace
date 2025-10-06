//
//  ContentView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/22/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Session type indicator
                Text(timerViewModel.currentSessionType.displayName)
                    .font(AppTypography.title3)
                    .foregroundColor(AppColors.secondaryText)

                // Timer display
                VStack(spacing: 8) {
                    CoffeeCupTimerView(
                        progress: timerViewModel.progress,
                        sessionType: timerViewModel.currentSessionType,
                        formattedTime: timerViewModel.formattedTime
                    )
                    

                    // Progress indicator
                    if !timerViewModel.isIdle {
                        ProgressView(value: timerViewModel.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: AppColors.accent))
                            .frame(width: 200)
                    }
                }

                // Preset selection (only when idle)
                if timerViewModel.isIdle {
                    PresetSelectionView(
                        selectedPreset: $timerViewModel.selectedPreset,
                        presets: timerViewModel.preferences.customFocusDurations.map { 
                            TimerPreset(durationTitle: "\($0)", minutes: $0)
                        }
                    )
                }

                // Timer controls
                TimerControlsView(timerViewModel: timerViewModel)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()
                        .onDisappear {
                            timerViewModel.objectWillChange.send()
                        }
                    ) {
                        Image(systemName: "gear")
                            .font(.title3)
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
        }
    }
}

#Preview {
    let localRepo = LocalSessionRepository()
    let remoteRepo = RemoteSessionRepository()
    let syncService = SessionSyncService(
        localRepository: localRepo,
        remoteRepository: remoteRepo
    )
    let timerViewModel = TimerViewModel(sessionSync: syncService)
    
    ContentView()
        .environmentObject(timerViewModel)
}
