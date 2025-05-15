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

    var memoryDatabase: MemoryDatabase {
        get { self[MemoryDatabase.self] }
        set { self[MemoryDatabase.self] = newValue }
    }

    var memoryRepository: MomoryRepository {
        get { self[MomoryRepository.self] }
        set { self[MomoryRepository.self] = newValue }
    }

    var emojiClient: EmojiClient {
        get { self[EmojiClient.self] }
        set { self[EmojiClient.self] = newValue }
    }
}
