//
//  ContentView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/22/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("25:00")
                .font(AppTypography.timerLarge)
                .foregroundColor(AppColors.primaryText)

            Text("Focus Timer")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.secondaryText)

            PrimaryButton(title: "Start Focus Session", action: {
                // TODO: Implement timer start
            })
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview {
    ContentView()
}
