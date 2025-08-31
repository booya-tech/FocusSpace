//
//  PresetSelectionView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/31/25.
//

import SwiftUI

struct PresetSelectionView: View {
    @Binding var selectedPreset: TimerPreset
    let presets: [TimerPreset]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Focus Duration")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(presets, id: \.id) { preset in
                    PresetButton(
                        preset: preset,
                        isSelected: selectedPreset.id == preset.id
                    )
                    {
                        selectedPreset = preset
                    }
                }
            }
        }
    }
}

#Preview {
    PresetSelectionView(selectedPreset: .constant(TimerPreset.defaults[0]), presets: TimerPreset.defaults)
}
