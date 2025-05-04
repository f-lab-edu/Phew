//
//  DailyRoutineFeature.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct DailyRoutineFeature {
    @ObservableState
    struct State: Equatable {
        var currentPage: Int = 0
        var dailyRoutineType: DailyRoutineType
        var selectedDate: Date
        var emojis: [String]?
        var tasks: [DailyRoutineTask] = [
            DailyRoutineTask(id: UUID(), taskType: .singleSelection, title: "Question1"),
            DailyRoutineTask(id: UUID(), taskType: .singleSelection, title: "Question2"),
            DailyRoutineTask(id: UUID(), taskType: .singleSelection, title: "Question3")
        ]
        var selectedItemsPerPage: [Int: String] = [:]
    }

    enum Action {
        case nextButtonTapped
        case backButtonTapped
        case doneButtonTapped
        case closeButtonTapped
        case delegate(Delegate)
        case emojisLoaded
        case setCurrentPage(Int)
        case setSelectedItemsPerPage(index: Int, selection: String?)

        enum Delegate {
            case save(DailyRoutineRecord)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.dailyRoutineRepository.addDailyRoutine) var addDailyRoutine
    @Dependency(\.emojiClient.loadEmojis) var loadEmojis
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                state.currentPage += 1
                return .none
            case .backButtonTapped:
                state.currentPage -= 1
                return .none
            case .doneButtonTapped:
                return .run { [state] send in
                    let responses = state.tasks.enumerated().compactMap { index, task in
                        DailyRoutineResponse(
                            id: UUID(),
                            question: task.title,
                            dailyRoutineResponseType: .emoji,
                            answerText: state.selectedItemsPerPage[index]?.toHexCode().first
                        )
                    }

                    let dailyRoutineRecord = DailyRoutineRecord(
                        date: state.selectedDate,
                        dailyRoutineType: state.dailyRoutineType,
                        dailyRoutineTask: state.tasks,
                        responses: responses
                    )

                    do {
                        try addDailyRoutine(dailyRoutineRecord)
                    } catch {
                        // 에러 처리
                    }
                    
                    await send(.delegate(.save(dailyRoutineRecord)))
                    await self.dismiss()
                }
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            case .emojisLoaded:
                do {
                    guard
                        let emojis = try loadEmojis()
                    else {
                        return .none
                    }
                    
                    let convertedEmojis = emojis.flatMap { $0.unicodeScalars.compactMap { $0.toEmoji() } }
                    
                    state.emojis = convertedEmojis
                } catch {
                    // 에러 처리
                }
                return .none
            case let .setCurrentPage(page):
                state.currentPage = page
                return .none
            case .setSelectedItemsPerPage(index: let index, selection: let selection):
                if let selection {
                    state.selectedItemsPerPage[index] = selection
                }
                return .none
            }
        }
    }
}
