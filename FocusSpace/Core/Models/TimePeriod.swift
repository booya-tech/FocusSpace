//
//  TimePeriod.swift
//  MonoTimer
//
//  Created by Panachai Sulsaksakul on 11/1/25.
//

import Foundation

enum TimePeriod: String, CaseIterable, Identifiable {
    case week = "Week"
    case year = "Lifetime"
    
    var id: String { rawValue }
    
    var chartDataPoints: Int {
        switch self {
        case .week: return 7    // 7 days
        case .year: return 12   // 12 months
        }
    }
}
