//
//  RoutineFeature.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

@Reducer
struct RoutineFeature {
    @ObservableState
    struct State: Equatable {
        var selectedIndex = 0
        var dailyRoutineType: DailyRoutineType
        var selectedDate: Date
    }

    enum Action {
        case nextButtonTapped
        case backButtonTapped
        case doneButtonTapped
        case closeButtonTapped
        case delegate(Delegate)

        enum Delegate {
            case save
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                state.selectedIndex += 1
                return .none
            case .backButtonTapped:
                state.selectedIndex -= 1
                return .none
            case .doneButtonTapped:
                @Dependency(\.dailyRoutineRepository.addDailyRoutine) var addDailyRoutine
                
                let dailyRoutineRecord = DailyRoutineRecord(
                    date: state.selectedDate,
                    dailyRoutineType: state.dailyRoutineType
                )

                do {
                    try addDailyRoutine(dailyRoutineRecord)
                } catch {
                    // 에러 처리
                }
                
                return .run { send in
                    await send(.delegate(.save))
                    await self.dismiss()
                }
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            }
        }
    }
}
