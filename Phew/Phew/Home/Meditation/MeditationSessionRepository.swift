//
//  MeditationSessionRepository.swift
//  Phew
//
//  Created by dong eun shin on 5/19/25.
//

import Dependencies
import Foundation

struct MeditationSessionRepository {
    var fetchMeditationSession: @Sendable (Date) throws -> MeditationSession?
    var updateMeditationSession: @Sendable (Date, TimeInterval) throws -> Void
}

extension MeditationSessionRepository: DependencyKey {
    static let liveValue = Self(
        fetchMeditationSession: { date in
            @Dependency(\.meditationSessionDatabase) var database

            let id = MeditationSession.makeID(date: date)

            return try database.fetchOneBy(id)
        }, updateMeditationSession: { date, duration in
            @Dependency(\.meditationSessionDatabase) var database


            let id = MeditationSession.makeID(date: date)

            if let existingSessions = try database.fetchOneBy(id) {
                try database.update(id, duration)
            } else {
                try database.add(date, duration)
            }
        }
    )
}
