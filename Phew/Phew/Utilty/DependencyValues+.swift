//
//  DependencyValues+.swift
//  Phew
//
//  Created by dong eun shin on 4/29/25.
//

import Dependencies

extension DependencyValues {
    var modelContextProvider: ModelContextProvider {
        get { self[ModelContextProvider.self] }
        set { self[ModelContextProvider.self] = newValue }
    }
    
    var dailyRoutineDatabase: DailyRoutineDatabase {
        get { self[DailyRoutineDatabase.self] }
        set { self[DailyRoutineDatabase.self] = newValue }
    }
    
    var dailyRoutineRepository: DailyRoutineRepository {
        get { self[DailyRoutineRepository.self] }
        set { self[DailyRoutineRepository.self] = newValue }
    }
}
