//
//  DateFomatters.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/20/25.
//

import Foundation

enum DateFormatters {
    /// Medium date style formatter (e.g., "Jan 19, 2025")
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// Short date style formatter (e.g., "1/19/25")
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// Time only formatter (e.g., "3:45 PM")
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// Full date and time formatter (e.g., "Jan 19, 2025 at 3:45 PM")
    static let fullDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

// MARK: - Date Extension for Convenience
extension Date {
    /// Format date as medium style (e.g., "Jan 19, 2025")
    var mediumFormat: String {
        DateFormatters.mediumDate.string(from: self)
    }
    
    /// Format date as short style (e.g., "1/19/25")
    var shortFormat: String {
        DateFormatters.shortDate.string(from: self)
    }
    
    /// Format time only (e.g., "3:45 PM")
    var timeFormat: String {
        DateFormatters.timeOnly.string(from: self)
    }
    
    /// Format full date and time (e.g., "Jan 19, 2025 at 3:45 PM")
    var fullFormat: String {
        DateFormatters.fullDateTime.string(from: self)
    }
}