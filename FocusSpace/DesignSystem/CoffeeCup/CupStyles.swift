//
//  CupStyles.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/7/25.
//

import SwiftUI

/// Available cup styles
enum CupStyle {
    case glass      // Current trapezoid style
    case mug        // Rounded mug with handle
    case minimal    // Simple rounded rectangle
}

// MARK: - Type-erased Shape Wrapper
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = { rect in
            shape.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

// MARK: - Glass Cup Shape (Trapezoid)
struct GlassCupShape: Shape {
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

// MARK: - Mug Cup Shape (Rounded with Handle)
struct MugCupShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Main cup body (rounded rectangle)
        let cupRect = CGRect(
            x: width * 0.15,
            y: height * 0.05,
            width: width * 0.7,
            height: height * 0.9
        )
        path.addRoundedRect(in: cupRect, cornerSize: CGSize(width: 20, height: 20))
        
        // Handle (curved path on the right)
        let handlePath = Path { p in
            let handleStart = CGPoint(x: width * 0.85, y: height * 0.3)
            let handleEnd = CGPoint(x: width * 0.85, y: height * 0.6)
            let control1 = CGPoint(x: width * 1.05, y: height * 0.35)
            let control2 = CGPoint(x: width * 1.05, y: height * 0.55)
            
            p.move(to: handleStart)
            p.addCurve(to: handleEnd, control1: control1, control2: control2)
        }
        path.addPath(handlePath)
        
        return path
    }
}

// MARK: - Minimal Cup Shape (Simple Rounded Rectangle)
struct MinimalCupShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Simple rounded rectangle
        let cupRect = CGRect(
            x: width * 0.2,
            y: height * 0.05,
            width: width * 0.6,
            height: height * 0.9
        )
        path.addRoundedRect(in: cupRect, cornerSize: CGSize(width: 15, height: 15))
        
        return path
    }
}
