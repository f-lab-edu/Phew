//
//  MemoryDatabase.swift
//  Phew
//
//  Created by dong eun shin on 5/5/25.
//

import Dependencies
import Foundation
import SwiftData

struct MemoryDatabase {
    var fetchOneBy: @Sendable (_ id: String) throws -> Memory?
    var add: @Sendable (Memory) throws -> Void
    var deleteAll: @Sendable () throws -> Void
    var deleteOneBy: @Sendable (_ id: String) throws -> Void
    var updateOneBy: @Sendable (_ id: String, _ memory: Memory) throws -> Void
}

extension MemoryDatabase: DependencyKey {
    static let liveValue = Self(
        fetchOneBy: { id in
            @Dependency(\.modelContextProvider.context) var context
            let memoryContext = try context()

            let predicate = #Predicate<Memory> { $0.id == id }
            let descriptor = FetchDescriptor<Memory>(predicate: predicate)

            return try memoryContext.fetch(descriptor).first
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
        },
        deleteOneBy: { id in
            @Dependency(\.modelContextProvider.context) var context
            let memoryContext = try context()

            let predicate = #Predicate<Memory> { $0.id == id }
            let descriptor = FetchDescriptor<Memory>(predicate: predicate)

            if let memory = try memoryContext.fetch(descriptor).first {
                memoryContext.delete(memory)
                try memoryContext.save()
            }
        },
        updateOneBy: { id, memory in
            @Dependency(\.modelContextProvider.context) var context
            let memoryContext = try context()

            let predicate = #Predicate<Memory> { $0.id == id }
            let descriptor = FetchDescriptor<Memory>(predicate: predicate)

            if let fetchedMemory = try memoryContext.fetch(descriptor).first {
                fetchedMemory.text = memory.text
                fetchedMemory.images = memory.images
                fetchedMemory.isGoodMemory = memory.isGoodMemory

                try memoryContext.save()
            }
        }
    )
}
