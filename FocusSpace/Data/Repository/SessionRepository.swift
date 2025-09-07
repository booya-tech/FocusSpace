//
//  SessionRepository.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/6/25.
//
//  Protocol for session data management
//


import Foundation

/// Repository protocol for managing session data
protocol SessionRepository {
    // Get sessions within a date range
    func getSessions(from startDate: Date?, to endDate: Date?) async throws -> [Session]

    // Save a single session
    func save(_ session: Session) async throws

    // Save multiple sessions
    func save(_ sessions: [Session]) async throws

    // Delete a session by id
    func delete(id: UUID) async throws

    // Get all sessions for current user
    func getAllSessions() async throws -> [Session]
}

extension SessionRepository {
    // Get all session (convenience method)
    func getAllSessions() async throws -> [Session] {
        return try await getSessions(from: nil, to: nil)
    }

    // Save multiple sessions (default implementation)
    func save(_ sessions: [Session]) async throws {
        for session in sessions {
            try await save(session)
        }
    }
}
