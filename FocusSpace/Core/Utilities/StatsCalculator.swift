//
//  StatsCalculator.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/20/25.
//
//  Statistics calculation utilities
//

import Foundation

enum StatsCalculator {
    /// Calculate total focus sessions
    static func totalFocusSessions(from sessions: [Session]) -> Int {
        sessions.filter { $0.type == .focus }.count
    }
    
    /// Calculate total focus time in minutes
    static func totalFocusMinutes(from sessions: [Session]) -> Int {
        sessions
            .filter { $0.type == .focus }
            .reduce(0) { total, session in
                total + Int(session.endAt.timeIntervalSince(session.startAt) / 60)
            }
    }
    
    /// Calculate current streak in days
    static func calculateStreak(from sessions: [Session]) -> Int {
        let calendar = Calendar.current
        let focusSessions = sessions
            .filter { $0.type == .focus }
            .sorted { $0.startAt > $1.startAt }
        
        guard !focusSessions.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for session in focusSessions {
            let sessionDate = calendar.startOfDay(for: session.startAt)
            
            if calendar.isDate(sessionDate, inSameDayAs: currentDate) {
                if streak == 0 { streak = 1 }
                continue
            } else if let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate),
                      calendar.isDate(sessionDate, inSameDayAs: previousDay) {
                streak += 1
                currentDate = previousDay
            } else {
                break
            }
        }
        
        return streak
    }
    
    /// Calculate longest streak in days
    static func calculateLongestStreak(from sessions: [Session]) -> Int {
        let calendar = Calendar.current
        let focusSessions = sessions
            .filter { $0.type == .focus }
            .sorted { $0.startAt < $1.startAt }
        
        guard !focusSessions.isEmpty else { return 0 }
        
        var longestStreak = 0
        var currentStreak = 1
        var previousDate = calendar.startOfDay(for: focusSessions[0].startAt)
        
        for session in focusSessions.dropFirst() {
            let sessionDate = calendar.startOfDay(for: session.startAt)
            
            if calendar.isDate(sessionDate, inSameDayAs: previousDate) {
                continue
            } else if let nextDay = calendar.date(byAdding: .day, value: 1, to: previousDate),
                      calendar.isDate(sessionDate, inSameDayAs: nextDay) {
                currentStreak += 1
                longestStreak = max(longestStreak, currentStreak)
            } else {
                currentStreak = 1
            }
            
            previousDate = sessionDate
        }
        
        return max(longestStreak, currentStreak)
    }
    
    /// Get sessions for today
    static func sessionsForToday(from sessions: [Session]) -> [Session] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return sessions.filter { session in
            calendar.isDate(session.startAt, inSameDayAs: today)
        }
    }
    
    /// Get sessions for current week
    static func sessionsForCurrentWeek(from sessions: [Session]) -> [Session] {
        let calendar = Calendar.current
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return []
        }
        
        return sessions.filter { session in
            session.startAt >= weekStart
        }
    }
}