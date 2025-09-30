//
//  ProgressRing.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/3/25.
//
//  Monochrome progress ring for daily goals
//

import SwiftUI

/// Circular progress ring with monochrome styling
struct ProgressRing: View {
    let progress: Double // 0.0 - 1.0
    let size: CGFloat
    let lineWidth: CGFloat

    init(progress: Double, size: CGFloat = 120, lineWidth: CGFloat = 8) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
    }

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(AppColors.secondaryBackground, lineWidth: lineWidth)
                .frame(width: size, height: size)

            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppColors.primaryText, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90)) // Start from the top
                .animation(.easeInOut(duration: 0.8), value: progress)
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        ProgressRing(progress: 0.3)
        ProgressRing(progress: 0.7)
        ProgressRing(progress: 1.0)
    }
    .padding()
}
