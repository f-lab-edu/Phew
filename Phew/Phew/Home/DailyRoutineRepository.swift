//
//  DailyRoutineRepository.swift
//  Phew
//
//  Created by dong eun shin on 4/28/25.
//

import SwiftUI
import SwiftData
import Dependencies

struct DailyRoutineRepository {
    var fetchDailyRoutine: @Sendable (Date, DailyRoutineType) throws -> DailyRoutineRecord?
    var addDailyRoutine: @Sendable (DailyRoutineRecord) throws -> Void
}

extension DailyRoutineRepository: DependencyKey {
    static let liveValue = Self(
        fetchDailyRoutine: { date, dailyRoutineType in
            @Dependency(\.dailyRoutineDatabase) var database
            
            let id = DailyRoutineRecord.makeID(date: date, dailyRoutineType: dailyRoutineType)
            let predicate = #Predicate<DailyRoutineRecord> { $0.id == id }
            let descriptor = FetchDescriptor<DailyRoutineRecord>(predicate: predicate)

            return try database.fetch(descriptor)
    }, addDailyRoutine: { record in
        @Dependency(\.dailyRoutineDatabase) var database

        try database.add(record)
    })
}
