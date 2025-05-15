//
//  DailyRoutineDatabase.swift
//  Phew
//
//  Created by dong eun shin on 4/29/25.
//

import Dependencies
import Foundation
import SwiftData

struct DailyRoutineDatabase {
    var fetchOneBy: @Sendable (_ id: String) throws -> DailyRoutineRecord?
    var add: @Sendable (DailyRoutineRecord) throws -> Void
    var deleteAll: @Sendable () throws -> Void
}

extension DailyRoutineDatabase: DependencyKey {
    static let liveValue = Self(
        fetchOneBy: { id in
            @Dependency(\.modelContextProvider.context) var context
            let movieContext = try context()

            let predicate = #Predicate<DailyRoutineRecord> { $0.id == id }
            let descriptor = FetchDescriptor<DailyRoutineRecord>(predicate: predicate)

            return try movieContext.fetch(descriptor).first
        },
        add: { dailyRoutineRecord in
            @Dependency(\.modelContextProvider.context) var context
            let movieContext = try context()

            movieContext.insert(dailyRoutineRecord)

            try movieContext.save()
        },
        deleteAll: {
            @Dependency(\.modelContextProvider.context) var context
            let modelContext = try context()

            let allRecords = try modelContext.fetch(FetchDescriptor<DailyRoutineRecord>())
            for record in allRecords {
                modelContext.delete(record)
            }

            try modelContext.save()
        }
    )
}
