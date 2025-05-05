//
//  MemoryDatabase.swift
//  Phew
//
//  Created by dong eun shin on 5/5/25.
//

import Foundation
import SwiftData
import Dependencies

struct MemoryDatabase {
    var fetchOneBy: @Sendable (_ id: String) throws -> Memory?
    var add: @Sendable (Memory) throws -> Void
    var deleteAll: @Sendable () throws -> Void
}

extension MemoryDatabase: DependencyKey {
    static let liveValue = Self(
        fetchOneBy: { id in
            @Dependency(\.modelContextProvider.context) var context
            let movieContext = try context()
            
            let predicate = #Predicate<Memory> { $0.id == id }
            let descriptor = FetchDescriptor<Memory>(predicate: predicate)

            return try movieContext.fetch(descriptor).first
        },
        add: { memory in
            @Dependency(\.modelContextProvider.context) var context
            let memoryContext = try context()

            memoryContext.insert(memory)
            
            try memoryContext.save()
        },
        deleteAll: {
            @Dependency(\.modelContextProvider.context) var context
            let memoryContext = try context()

            let allRecords = try memoryContext.fetch(FetchDescriptor<Memory>())
            for record in allRecords {
                memoryContext.delete(record)
            }

            try memoryContext.save()
        }
    )
}
