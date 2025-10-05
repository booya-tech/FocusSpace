//
//  MainTabView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/27/25.
//
//  Main app interface after authentication
//

import SwiftUI

/// Main tab-based interface for authenticated users
struct MainTabView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject var timerViewModel: TimerViewModel
    // Sync Service
    @StateObject private var localRepository = LocalSessionRepository()
    @StateObject private var syncService: SessionSyncService
    @State private var isSyncing = true

    // Initialization
    init() {
        let localRepository = LocalSessionRepository()
        let remoteRepository = RemoteSessionRepository()
        let syncService = SessionSyncService(localRepository: localRepository, remoteRepository: remoteRepository)

        let timerViewModel = TimerViewModel(sessionSync: syncService)

        self._localRepository = StateObject(wrappedValue: localRepository)
        self._syncService = StateObject(wrappedValue: syncService)
        self._timerViewModel = StateObject(wrappedValue: timerViewModel)
    }

    var body: some View {
        TabView {
            // Timer Tab
            NavigationStack {
                ContentView()
                    .environmentObject(timerViewModel)
                    .navigationTitle("Focus Timer")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "timer")
                Text("Timer")
            }
            // Dashboard Tab
            NavigationStack {
                DashboardView()
                    .environmentObject(timerViewModel)
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Dashboard")
            }
            // Profile Tab (placeholder)
            NavigationStack {
                VStack {
                    if let user = authService.currentUser {
                        Text("Email: \(user.email ?? "Unknown")")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.secondaryText)
                    }

                    Spacer()

                    PrimaryButton(title: "Sign Out") {
                        Task {
                            try? await authService.signOut()
                        }
                    }
                    .padding()
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "person.circle")
                Text("Profile")
            }
        }
        .overlay {
            if isSyncing {
                LoadingView()
            }
        }
        .accentColor(AppColors.accent)
        .task {
            // Sync on app launch
            await timerViewModel.syncOnForeground()
            isSyncing = false
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService())
}
