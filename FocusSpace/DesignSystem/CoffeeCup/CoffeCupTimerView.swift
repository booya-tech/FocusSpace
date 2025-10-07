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
    let cupStyle: CupStyle
    
    var body: some View {
        VStack(spacing: 24) {
            // Coffee Cup
            ZStack(alignment: .bottom) {
                // Cup outline
                // Cup outline
                cupShape
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: 200, height: 240)

                // Filling liquid with gradient
                cupShape
                    .fill(
                        LinearGradient(
                            colors: fillColors,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
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

    // MARK: - Computed Properties
    private var cupShape: some Shape {
        switch cupStyle {
        case .glass:
            return AnyShape(GlassCupShape())
        case .mug:
            return AnyShape(MugCupShape())
        case .minimal:
            return AnyShape(MinimalCupShape())
        }
    }
    
    // private var fillColor: Color {
    //     switch sessionType {
    //     case .focus:
    //         return Color.black.opacity(0.9)
    //     case .shortBreak, .longBreak:
    //         return Color.black.opacity(0.4)
    //     }
    // }
    private var fillColors: [Color] {
        switch sessionType {
        case .focus:
            // Rich dark coffee gradient
            return [
                Color(red: 0.15, green: 0.1, blue: 0.05),
                Color(red: 0.25, green: 0.18, blue: 0.1),
            ]
        case .shortBreak:
            // Light latte gradient
            return [
                Color(red: 0.7, green: 0.6, blue: 0.5).opacity(0.6),
                Color(red: 0.8, green: 0.7, blue: 0.6).opacity(0.7),
            ]
        case .longBreak:
            // Medium cappuccino gradient
            return [
                Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.7),
                Color(red: 0.5, green: 0.4, blue: 0.3).opacity(0.8),
            ]
        }
    }
}

// MARK: - Preview
#Preview("All Styles") {
    ScrollView {
        VStack(spacing: 40) {
            ForEach([
                ("Glass", CupStyle.glass, 0.95),
                ("Mug", CupStyle.mug, 0.6),
                ("Minimal", CupStyle.minimal, 0.3)
            ], id: \.0) { name, style, progress in
                VStack {
                    Text(name + " Style")
                        .font(.caption)
                        .foregroundColor(.gray)
                    CoffeeCupTimerView(
                        progress: progress,
                        sessionType: progress > 0.7 ? .focus : .longBreak,
                        formattedTime: "25:00",
                        cupStyle: style
                    )
                }
            }
        }
        .padding()
    }
}
