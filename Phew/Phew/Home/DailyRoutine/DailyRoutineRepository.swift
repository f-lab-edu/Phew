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
            
            return try database.fetchOneBy(id)
        }, addDailyRoutine: { record in
            @Dependency(\.dailyRoutineDatabase) var database

            try database.add(record)
    })
}
