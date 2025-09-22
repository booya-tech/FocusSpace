//
//  AddDurationSheet.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/22/25.
//

import SwiftUI

struct AddDurationSheet: View {
    @Binding var newDuration: Int
    let range: ClosedRange<Int>
    let onAdd: (Int) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Text("Add Custom Duration")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(newDuration) minutes")
                        .font(AppTypography.largeTitle)
                        .foregroundColor(AppColors.accent)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 24) {
                    Text("Select Duration")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Picker("Duration", selection: $newDuration) {
                        ForEach(Array(range), id: \.self) { minutes in
                            Text("\(minutes) min").tag(minutes)
                        }
                        .pickerStyle(.inline)
                        .frame(height: 150)
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle("Add Duration")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(AppTypography.body)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            onAdd(newDuration)
                            dismiss()
                        }
                        .font(AppTypography.body)
                        .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    AddDurationSheet(
        newDuration: .constant(25),
        range: 5...120,
        onAdd: { _ in }
    )
}
