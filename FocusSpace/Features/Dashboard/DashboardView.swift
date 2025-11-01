//
//  DashboardView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/5/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel

    init() {
        _viewModel = StateObject(wrappedValue: DashboardViewModel())
    }

    var body: some View {
        Group {
            if hasAnySessions {
                dashboardContent
            } else {
                emptyState
            }
        }        
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .onAppear() {
            updateStats()
        }
        .onChange(of: timerViewModel.completedSessions) {
            updateStats()
        }
    }

    private var dashboardContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Daily Goal Section
                dailyGoalSection

                // Stats Grid
                statsGrid

                // Period Selector
                PeriodSelector(selectedPeriod: $viewModel.selectedPeriod)
                    .onChange(of: viewModel.selectedPeriod) {
                        viewModel.updatePeriodStats(with: timerViewModel.completedSessions)
                    }

                // Period Stats Section
                periodStatsSection

                // Weekly Chart
                WeeklyChart(data: viewModel.periodChartData, title: viewModel.selectedPeriod.rawValue)

                // Bottom padding
                Spacer(minLength: 100)
            }
            .padding()
        }
    }

    private var periodStatsSection: some View {
        VStack(spacing: 16) {
            Text("Session History")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Sessions")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.secondaryText)
                    Text("\(viewModel.periodStats.totalSessions)")
                        .font(AppTypography.title2)
                        .foregroundColor(AppColors.primaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Minutes")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.secondaryText)
                    Text("\(viewModel.periodStats.totalMinutes)")
                        .font(AppTypography.title2)
                        .foregroundColor(AppColors.primaryText)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
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

    private var emptyState: some View {
        EmptyStateView(
            icon: "chart.bar.fill",
            title: "No Sessions Yet",
            message: "Start your first focus session to see your productivity stats and progress",
            actionTitle: "Start First Session",
            action: {
                switchToTimerTab()
            }
        )
    }

    private var hasAnySessions: Bool {
        !timerViewModel.completedSessions.isEmpty
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
        .frame(maxWidth: .infinity)
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

    /// Description
    /// Notification Center to notify switch tab to MainTabView
    private func switchToTimerTab() {
        NotificationCenter.default.post(name: .switchToTimerTab, object: nil)
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
    
    return NavigationStack {
        DashboardView()
            .environmentObject(timerViewModel)
    }
}
