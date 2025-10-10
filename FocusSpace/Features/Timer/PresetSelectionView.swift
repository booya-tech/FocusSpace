//
//  PresetSelectionView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/31/25.
//

import SwiftUI

struct PresetSelectionView: View {
    let selectedDuration: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Focus Duration")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText)
            
            Text("\(selectedDuration) min")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.primaryText)
                .monospacedDigit()
        }
    }
}

#Preview {
    PresetSelectionView(selectedDuration: 25)
}
