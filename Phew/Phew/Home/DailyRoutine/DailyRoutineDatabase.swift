//
//  DailyRoutineDatabase.swift
//  Phew
//
//  Created by dong eun shin on 4/29/25.
//

import SwiftUI
import SwiftData
import Dependencies
import OSLog

private let logger = Logger(subsystem: "Phew", category: "DailyRoutineDatabase")

struct DailyRoutineDatabase {
    var fetchOneBy: @Sendable (_ id: String) throws -> DailyRoutineRecord?
    var add: @Sendable (DailyRoutineRecord) throws -> Void
}

extension DailyRoutineDatabase: DependencyKey {
    static let liveValue = Self(
        fetchOneBy: { id in
            @Dependency(\.modelContextProvider.context) var context
            let movieContext = try context()
            
            let predicate = #Predicate<DailyRoutineRecord> { $0.id == id }
            let descriptor = FetchDescriptor<DailyRoutineRecord>(predicate: predicate)

            return try movieContext.fetch(descriptor).first
        }, add: { dailyRoutineRecord in
            @Dependency(\.modelContextProvider.context) var context
            let movieContext = try context()

            movieContext.insert(dailyRoutineRecord)
        }
    )
}
