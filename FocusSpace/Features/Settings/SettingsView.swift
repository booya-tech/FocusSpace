//
//  SettingsView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/21/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var preferences = AppPreferences.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section("Timer Settings") {
                    // Custom Focus Durations
                    NavigationLink {
                        // add view
                    } label: {
                        
                    }
                    // Custom Break Durations
                    NavigationLink {
                        // add view
                    } label: {
                        
                    }              

                    // Strict Mode Toggle
                    HStack {
                        // add view
                        Spacer()
                        Toggle("", isOn: $preferences.isSoundEnabled)
                            .labelsHidden()
                    }     
                }
                // MARK: - Goal & Tracking
                Section("Goal & Tracking") {
                    // Daily Focus Goal
                    NavigationLink {
                        // add view
                    } label: {
                        // add view
                    }
                }

                // MARK: - Audio & Haptics
                Section("Audio & Haptics") {
                    // Sound Toggle
                    HStack {
                        // add view
                        Spacer()
                        Toggle("", isOn: $preferences.isSoundEnabled)
                            .labelsHidden()
                    }
                    // Haptics Toggle
                    HStack {
                        // add view
                        Spacer()
                        Toggle("", isOn: $preferences.isHapticsEnabled)
                    }
                }

                // MARK: - Reset
                Section("Reset") {
                    Button {
                        preferences.resetToDefaults()
                        HapticManager.shared.light()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(.red)
                            Text("Reset to Defaults")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
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
    SettingsView()
}
