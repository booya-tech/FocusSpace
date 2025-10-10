//
//  CupAnimations.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/7/25.
//

import SwiftUI

// MARK: - Foam Layer
struct FoamLayer: View {
    let cupStyle: CupStyle
    @State private var bubbleOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Main foam ellipse
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color(white: 0.95).opacity(0.8)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: foamWidth, height: 18)
                .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
            
            // Foam bubbles
            HStack(spacing: 8) {
                ForEach(0..<5) { index in
                    Circle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: CGFloat.random(in: 4...8))
                        .offset(y: bubbleOffset)
                }
            }
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
                ) {
                    bubbleOffset = CGFloat.random(in: -2...2)
                }
            }
        }
    }
    
    private var foamWidth: CGFloat {
        switch cupStyle {
        case .glass: return 175
        case .mug: return 135
        case .minimal: return 115
        }
    }
}
