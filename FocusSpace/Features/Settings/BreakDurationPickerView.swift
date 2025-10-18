//
//  BreakDurationPickerView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/5/25.
//

import SwiftUI

struct BreakDurationPickerView: View {
    @Binding var selectedDuration: Int
    
    let availableDurations = [5, 10, 15, 20, 25, 30]
    
    var body: some View {
        List {
            Section {
                ForEach(availableDurations, id: \.self) { duration in
                    HStack {
                        Text("\(duration) min")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        if selectedDuration == duration {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColors.accent)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedDuration = duration
                        HapticManager.shared.light()
                    }
                }
            } header: {
                Text("Select Break Duration")
            } footer: {
                Text("Choose how long your break sessions will last after completing a focus session.")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .navigationTitle("Break Duration")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BreakDurationPickerView(selectedDuration: .constant(5))
    }
}
