//
//  CustomDurationsView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/21/25.
//
//  Custom timer duration editor
//

import SwiftUI

// Edit focus/break duration lists with add/remove/reorder
@available(*, deprecated, message: "This class is no longer supported. Use BreakDurationPickerView instead.")
struct CustomDurationsView: View {
    let title: String
    @Binding var durations: [Int]
    let range: ClosedRange<Int>

    @Environment(\.dismiss) private var dismiss
    @State private var showingAddDuration = false
    @State private var newDuration = 25
    
    var body: some View {
        List {
            Section {
                ForEach(durations.indices, id: \.self) { index in
                    HStack {
                        Text("\(durations[index]) min")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.primaryText)

                        Spacer()

                        Button {
                            withAnimation {
                                durations.remove(at: index)
                                HapticManager.shared.light()
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                .onMove { source, destination in
                    durations.move(fromOffsets: source, toOffset: destination)
                    HapticManager.shared.light()
                }
            } header: {
                Text("Current Durations")
            } footer: {
                Text("Tap and hold to reorder. Use the minus button to remove.")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.secondaryText)
            }

            Section {
                Button {
                    showingAddDuration = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.accent)

                        Text("Add Duration")
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .font(AppTypography.body)
            }
        }
        .sheet(isPresented: $showingAddDuration) {
            AddDurationSheet(
                newDuration: $newDuration,
                range: range,
                onAdd: { duration in
                    if !durations.contains(duration) {
                        durations.append(duration)
                        durations.sort()
                        HapticManager.shared.medium()
                    }
                }
            )
        }
    }
}

#Preview {
    CustomDurationsView(
        title: "Focus Durations",
        durations: .constant([25, 30, 45]),
        range: 5...120    
    )
}
