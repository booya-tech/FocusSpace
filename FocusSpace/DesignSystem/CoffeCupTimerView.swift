//
//  CoffeCupTimerView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/6/25.
//  Animated coffee cup timer display
//

import SwiftUI

/// Animated coffee cup that fills based on timer progress
struct CoffeeCupTimerView: View {
    let progress: Double // 0.0 to 1.0
    let sessionType: SessionType
    let formattedTime: String
    
    var body: some View {
        VStack(spacing: 24) {
            // Coffee Cup
            ZStack(alignment: .bottom) {
                // Cup outline
                CupShape()
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: 200, height: 240)
                
                // Filling liquid
                CupShape()
                    .fill(fillColor)
                    .frame(width: 200, height: 240)
                    .mask(
                        Rectangle()
                            .frame(height: 240 * progress)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    )
                    .animation(.easeInOut(duration: 1.0), value: progress)
                
                // Steam (when full or almost full)
                if progress > 0.8 {
                    SteamView()
                        .offset(y: -120)
                }
            }
            .frame(height: 280)
            
            // Time Display
            Text(formattedTime)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
            
            // Session Type Label
            Text(sessionType.displayName.uppercased())
                .font(.system(size: 14, weight: .semibold, design: .default))
                .tracking(2)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    private var fillColor: Color {
        switch sessionType {
        case .focus:
            return Color.black.opacity(0.9)
        case .shortBreak, .longBreak:
            return Color.black.opacity(0.4)
        }
    }
}

// MARK: - Cup Shape - Glass Style
struct CupShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Top rim
        let topWidth = width * 0.9
        let topLeft = (width - topWidth) / 2
        let topRight = topLeft + topWidth
        
        // Bottom base
        let bottomWidth = width * 0.6
        let bottomLeft = (width - bottomWidth) / 2
        let bottomRight = bottomLeft + bottomWidth
        
        // Draw cup outline (trapezoid)
        path.move(to: CGPoint(x: topLeft, y: 0))
        path.addLine(to: CGPoint(x: topRight, y: 0))
        path.addLine(to: CGPoint(x: bottomRight, y: height))
        path.addLine(to: CGPoint(x: bottomLeft, y: height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Steam Animation
struct SteamView: View {
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<3) { index in
                SteamWave(delay: Double(index) * 0.3)
            }
        }
    }
}

struct SteamWave: View {
    let delay: Double
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.black.opacity(0.3))
            .frame(width: 3, height: 20)
            .offset(y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    offset = -40
                    opacity = 0
                }
            }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        // Focus session at 50% progress
        CoffeeCupTimerView(
            progress: 0.5,
            sessionType: .focus,
            formattedTime: "25:00"
        )
        
        // Break session at 80% progress
        CoffeeCupTimerView(
            progress: 0.8,
            sessionType: .longBreak,
            formattedTime: "05:00"
        )
    }
}
