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
            NavigationView {
                ContentView()
                    .environmentObject(timerViewModel)
                    .navigationTitle("Focus Timer")
                    .navigationBarTitleDisplayMode(.inline)
                //                    .toolbar {
                //                        ToolbarItem(placement: .navigationBarTrailing) {
                //                            Button("Sign Out") {
                //                                Task {
                //                                    try? await authService.signOut()
                //                                }
                //                            }
                //                            .font(AppTypography.caption)
                //                            .foregroundColor(AppColors.secondaryText)
                //                        }
                //                    }
            }
            .tabItem {
                Image(systemName: "timer")
                Text("Timer")
            }
            // Profile Tab (placeholder)
            NavigationView {
                VStack {
                    Text("Profile")
                        .font(AppTypography.title2)

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
            // Dashboard Tab
            NavigationView {
                DashboardView()
                    .environmentObject(timerViewModel)
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Dashboard")
            }
        }
        .accentColor(AppColors.accent)
        .task {
            // Sync on app launch
            await timerViewModel.syncOnForeground()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService())
}