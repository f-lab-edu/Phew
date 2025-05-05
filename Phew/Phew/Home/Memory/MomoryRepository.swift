//
//  MomoryRepository.swift
//  Phew
//
//  Created by dong eun shin on 5/5/25.
//

import Foundation
import Dependencies

struct MomoryRepository {
    var fetchMemory: @Sendable (Date) throws -> Memory?
    var addMemory: @Sendable (_ memory: Memory) throws -> Void
}

extension MomoryRepository: DependencyKey {
    static let liveValue = Self(
        fetchMemory: { date in
            @Dependency(\.memoryDatabase) var database
            
            let id = date.monthAndDay()
            
            return try database.fetchOneBy(id)
        }, addMemory: { record in
            @Dependency(\.memoryDatabase) var database

            try database.add(record)
    })
}
