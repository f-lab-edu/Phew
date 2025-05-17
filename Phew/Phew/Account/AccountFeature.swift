//
//  AccountFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/16/25.
//

import ComposableArchitecture
import SwiftUI

enum TaskType: String, Equatable, CaseIterable {
    case meditation
    case journal
    case dailyRoutine

    var title: String {
        switch self {
        case .meditation:
            return "Meditation"
        case .journal:
            return "Journal"
        case .dailyRoutine:
            return "Daily Routine"
        }
    }
}

struct TaskItem: Identifiable, Equatable, Hashable {
    let id: UUID
    var type: TaskType
}


@Reducer
struct AccountFeature {
    @ObservableState
    struct State: Equatable {
        var tasks: [TaskItem] = [
            TaskItem(id: UUID(), type: .dailyRoutine),
            TaskItem(id: UUID(), type: .journal),
            TaskItem(id: UUID(), type: .meditation)
        ]
        var taskDetail: TaskDetailFeature.State?
    }

    enum Action: Equatable {
        case selectTask(TaskItem)
        case taskDetail(TaskDetailFeature.Action)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectTask(let task):
                state.taskDetail = TaskDetailFeature.State(taskType: task.type)
            return .none
            default:
                return .none
            }
        }
        .ifLet(\.taskDetail, action: \.taskDetail) {
            TaskDetailFeature()
        }
    }
}
