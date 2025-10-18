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
        GeometryReader { geometry in
            Group {
                if geometry.size.height < 700 {
                    // Small screens: enable scrolling
                    ScrollView(showsIndicators: false) {
                        contentView
                    }
                } else {
                    // Large screens: no scrolling needed
                    contentView
                }
            }
        }
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

    // Extract content to a computed property
    private var contentView: some View {
        VStack() {
            Spacer()
            // Session type indicator
            Text(timerViewModel.currentSessionType.displayName.uppercased())
                .font(AppTypography.title3)
                .foregroundColor(AppColors.primaryText)
            
            // Timer display
            VStack(spacing: 10) {
                CoffeeCupTimerView(
                    progress: timerViewModel.progress,
                    sessionType: timerViewModel.currentSessionType,
                    formattedTime: timerViewModel.formattedTime,
                    cupStyle: .glass
                )
                
                
                // Progress indicator
                if !timerViewModel.isIdle {
                    ProgressView(value: timerViewModel.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: AppColors.accent))
                        .frame(width: 200)
                }
                
                Spacer()
                // Preset selection (only when idle)
                if timerViewModel.isIdle {
                    PresetSelectionView(
                        selectedDuration: timerViewModel.preferences.selectedFocusDuration
                    )
                }
                
                Spacer()
                
                // Timer controls
                TimerControlsView(timerViewModel: timerViewModel)
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
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
