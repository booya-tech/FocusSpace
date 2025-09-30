//
//  SessionDTO.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/6/25.
//

import Foundation

/// DTO for Supabase sessions table
struct SessionDTO: Codable {
    let id: String
    let user_id: String?
    let session_type: String
    let start_at: String
    let end_at: String
    let duration_minutes: Int
    let tag: String?
    let created_at: String?
    
    init(from session: Session) {
        self.id = session.id.uuidString
        self.user_id = nil // Supabase handles this automatically with RLS
        self.session_type = session.type.rawValue
        self.start_at = session.startAt.ISO8601Format()
        self.end_at = session.endAt.ISO8601Format()
        self.duration_minutes = session.durationMinutes
        self.tag = session.tag
        self.created_at = nil
    }
    
    func toSession() -> Session {
        Session(
            type: SessionType(rawValue: session_type) ?? .focus,
            startAt: ISO8601DateFormatter().date(from: start_at) ?? Date(),
            endAt: ISO8601DateFormatter().date(from: end_at) ?? Date(),
            tag: tag
        )
    }
}
