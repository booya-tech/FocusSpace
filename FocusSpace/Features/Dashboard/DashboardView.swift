//
//  DashboardView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/5/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @EnvironmentObject var timerViewModel: TimerViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Daily Goal Section
                dailyGoalSection

                // Stats Grid
                statsGrid

                // Weekly Chart
                WeeklyChart(data: viewModel.weeklyData)

                // Bottom padding
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .onAppear() {
            updateStats()
        }
        .onChange(of: timerViewModel.completedSessions) { _ in
            updateStats()
        }
    }

    private var dailyGoalSection: some View {
        VStack(spacing: 16) {
            Text("Daily Goal")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.primaryText)

            ZStack {
                ProgressRing(
                    progress: viewModel.todayStats.dailyGoalProgress,
                    size: 120,
                    lineWidth: 10
                )

                VStack(spacing: 8) {
                    Text("\(viewModel.todayStats.totalMinutes)")
                        .font(AppTypography.title1)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.primaryText)
                    Text("of \(viewModel.dailyGoalMinutes) min")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }

            Text(goalStatusText)
                .font(AppTypography.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.secondaryBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.secondaryText.opacity(0.2), lineWidth: 1)
                }
        )
    }

    private var statsGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16
        ) {
            StatsCard(
                title: "Today",
                value: "\(viewModel.todayStats.totalSessions)",
                subtitle: "sessions"
            )
            StatsCard(
                title: "This Week",
                value: "\(viewModel.weeklyStats.totalSessions)",
                subtitle: "sessions"
            )
            StatsCard(
                title: "Current Streak",
                value: "\(viewModel.todayStats.currentStreak)",
                subtitle: "days"
            )
            StatsCard(
                title: "Best Streak",
                value: "\(viewModel.todayStats.longestStreak)",
                subtitle: "days"
            )
        }
    }

    private var goalStatusText: String {
        let progress = viewModel.todayStats.dailyGoalProgress
        let remaining = viewModel.dailyGoalMinutes - viewModel.todayStats.totalMinutes

        if progress >= 1.0 {
            return "Goal completed! Great Work!"
        } else if progress >= 0.5 {
            return "You're halfway there! \(remaining) minutes to go."
        } else if viewModel.todayStats.totalMinutes > 0 {
            return "Good start! \(remaining) minutes remaining."
        } else {
            return "Start your first session today!"
        }
    }

    private func updateStats() {
        viewModel.updateStats(with: timerViewModel.completedSessions)
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
    
    return NavigationView {
        DashboardView()
            .environmentObject(timerViewModel)
    }
}
