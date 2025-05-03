//
//  SwiftDataModelConfigurationProvider.swift
//  Phew
//
//  Created by dong eun shin on 4/28/25.
//

import SwiftData
import Dependencies

struct ModelContextProvider {
    var context: () throws -> ModelContext
}

extension ModelContextProvider: DependencyKey {
    public static let liveValue = Self(
        context: {
            do {
                let schema = Schema([
                    DailyRoutineRecord.self,
                    DailyRoutineResponse.self,
                    DailyRoutineTask.self
                ])
                let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
                let container = try ModelContainer(for: schema, configurations: [configuration])
                return ModelContext(container)
            } catch {
                fatalError("Failed to create container.")
            }
        }
    )
}
