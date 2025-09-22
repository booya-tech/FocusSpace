//
//  Typography.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/23/25.
//

import SwiftUI

struct AppTypography {
    // Timer display
    static let timerLarge = Font.system(size: 72, weight: .light, design: .monospaced)
    static let timerMedium = Font.system(size: 48, weight: .light, design: .monospaced)

    // Headers
    static let title1 = Font.title
    static let title2 = Font.title2
    static let title3 = Font.title3
    static let headline = Font.headline
    static let largeTitle = Font.largeTitle

    // Body Text
    static let body = Font.body
    static let caption = Font.caption

    // Buttons
    static let buttonText = Font.body.weight(.medium)
}
