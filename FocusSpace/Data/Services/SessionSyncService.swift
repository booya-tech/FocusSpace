//
//  SessionSyncService.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 9/6/25.
//

import Foundation

@MainActor
final class SessionSyncService: ObservableObject {
    @Published private(set) var isSyncing = false
    @Published private(set) var lastSyncDate: Date?

    private let localRepository: LocalSessionRepository
    private let remoteRepository: RemoteSessionRepository

    init(
        localRepository: LocalSessionRepository,
        remoteRepository: RemoteSessionRepository
    ) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }

    // Public Interface
    // Get sessions from local cache (fast)
    func getSessions(from startDate: Date? = nil, to endDate: Date? = nil) async throws -> [Session] {
        return try await localRepository.getSessions(from: startDate, to: endDate)
    }

    // Save session to both local and remote
    func saveSession(_ session: Session) async throws {
        // Save locally first (immediate feedback)
        try await localRepository.save(session)

        // Then sync to remote
        do {
            try await remoteRepository.save(session)
        } catch {
            Logger.log("Remote save failed, will retry on next sync: \(error)")
        }
    }


    // Delete session from both local and remote
    func deleteSession(id: UUID) async throws {
        try await localRepository.delete(id: id)

        do {
            try await remoteRepository.delete(id: id)
        } catch {
            Logger.log("Remote delete failed: \(error)")
        }
    }

    // Force full synchronization
    func syncNow() async throws {
        guard !isSyncing else { return }

        isSyncing = true

        defer { isSyncing = false }

        do {
            // Get remote sessions
            let remoteSessions = try await remoteRepository.getSessions(from: nil, to: nil)
            // Replace local cache with remote data
            localRepository.replaceAll(with: remoteSessions)

            lastSyncDate = Date()
            Logger.log("Sync completed: \(remoteSessions.count) sessions")
        } catch {
            Logger.log("Sync failed: \(error)")
            throw error
        }
    }

    // Sync on app launch/foreground
    func syncOnAppForeground() async {
        do {
            try await syncNow()
        } catch {
            Logger.log("Background sync failed: \(error)")
        }
    }

    // Check if sync is needed
    private func shouldSync() -> Bool {
        guard let lastSync = lastSyncDate else { return true }
        return Date().timeIntervalSince(lastSync) > 300 // 5 minutes
    }

    // Repository Access
    // Direct access to local repository
    var localRepo: LocalSessionRepository { localRepository } 

    // Direct access to remote repository
    var remoteRepo: RemoteSessionRepository { remoteRepository }
}
