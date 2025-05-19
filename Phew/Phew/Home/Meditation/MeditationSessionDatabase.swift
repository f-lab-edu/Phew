//
//  MeditationSessionDatabase.swift
//  Phew
//
//  Created by dong eun shin on 5/19/25.
//

import Dependencies
import Foundation
import SwiftData

struct MeditationSessionDatabase {
    var add: @Sendable (_ date: Date,_ duration: TimeInterval) throws -> Void
    var fetchOneBy: @Sendable (_ id: String) throws -> MeditationSession?
    var update: @Sendable (_ id: String,_ duration: TimeInterval) throws -> Void
    var deleteAll: @Sendable () throws -> Void
}

extension MeditationSessionDatabase: DependencyKey {
    static let liveValue = Self(
        add: { date, duration in
            @Dependency(\.modelContextProvider.context) var context
            let modelContext = try context()

            let newSession = MeditationSession(date: date)
            modelContext.insert(newSession)

            try modelContext.save()
        },
        fetchOneBy: { id in
            @Dependency(\.modelContextProvider.context) var context
            let modelContext = try context()


            let predicate = #Predicate<MeditationSession> { $0.id == id }

            let descriptor = FetchDescriptor<MeditationSession>(predicate: predicate)

            return try modelContext.fetch(descriptor).first
        },
        update: { id, duration in
            @Dependency(\.modelContextProvider.context) var context
            let modelContext = try context()

            let allRecords = try modelContext.fetch(FetchDescriptor<MeditationSession>())

            let predicate = #Predicate<MeditationSession> { $0.id == id }

            let descriptor = FetchDescriptor<MeditationSession>(predicate: predicate)

            let existingSessions = try modelContext.fetch(descriptor)

            if let session = existingSessions.first {
                session.duration += duration
            }

            try modelContext.save()
        },
        deleteAll: {
            @Dependency(\.modelContextProvider.context) var context
            let modelContext = try context()

            let allRecords = try modelContext.fetch(FetchDescriptor<MeditationSession>())
            for record in allRecords {
                modelContext.delete(record)
            }

            try modelContext.save()
        }
    )
}
