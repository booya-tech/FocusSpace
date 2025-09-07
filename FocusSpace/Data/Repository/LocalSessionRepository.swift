//
//  LocalSessionRepository.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/6/25.
//
//  Local storage implementation for sessions
//

/// Local in-memory session storage (fallback/cache)
import Foundation

/// Local in-memory session storage (fallback/cache)
@MainActor
final class LocalSessionRepository: SessionRepository, ObservableObject {
    @Published private var sessions: [Session] = []
    
    func getSessions(from startDate: Date?, to endDate: Date?) async throws -> [Session] {
        var filterSessions = sessions

        if let startDate = startDate {
            filterSessions = filterSessions.filter { $0.startAt >= startDate}
        }

        if let endDate = endDate {
            filterSessions = filterSessions.filter { $0.endAt <= endDate }
        }

        return filterSessions.sorted { $0.startAt > $1.startAt }
    }
    
    func save(_ session: Session) async throws {
        sessions.removeAll { $0.id == session.id }  
        sessions.append(session) 
    }

    func delete(id: UUID) async throws {
        sessions.removeAll { $0.id == id }
    }

    func getAllSessions() async throws -> [Session] {
        return sessions.sorted { $0.startAt > $1.startAt }
    }

    func replaceAll(with newSessions: [Session]) {
        sessions = newSessions
    }
}
