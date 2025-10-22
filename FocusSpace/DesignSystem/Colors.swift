//
//  Colors.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/23/25.
//

import SwiftUI

struct AppColors {
    // Primary monochrome colors
    static let primary = Color.primary
    static let primaryRevert = Color("PrimaryRevertColor")
    static let secondary = Color.secondary

    // Background colors
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(.clear)
    static let cardBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)

    // Accent for focus state
    static let accent = Color.accentColor

    // Text colors
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let tertiaryText = Color(UIColor.tertiaryLabel)
    static let placeholderText = Color(UIColor.placeholderText)

    // Separator
    static let separator = Color(UIColor.separator)
    static let divider = Color(UIColor.separator)
    
    // Status Colors
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
    static let info = Color.blue
}
