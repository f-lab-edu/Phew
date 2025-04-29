//
//  DailyRoutineDatabase.swift
//  Phew
//
//  Created by dong eun shin on 4/29/25.
//

import SwiftUI
import SwiftData
import Dependencies

struct DailyRoutineDatabase {
    var fetch: @Sendable (FetchDescriptor<DailyRoutineRecord>) throws -> DailyRoutineRecord?
    var add: @Sendable (DailyRoutineRecord) throws -> Void
}

extension DailyRoutineDatabase: DependencyKey {
    static let liveValue = Self(
        fetch: { descriptor in
            do {
                @Dependency(\.modelContextProvider.context) var context
                let movieContext = try context()
                return try movieContext.fetch(descriptor).first
            } catch {
                return nil
            }
        }, add: { dailyRoutineRecord in
            do {
                @Dependency(\.modelContextProvider.context) var context
                let movieContext = try context()
                
                movieContext.insert(dailyRoutineRecord)
            } catch {

            }
        }
    )
}
