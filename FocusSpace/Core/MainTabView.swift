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

    var body: some View {
        TabView {
            // Timer Tab
            NavigationView {
                ContentView()
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
        }
        .accentColor(AppColors.accent)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService())
}
