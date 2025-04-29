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
    struct State {
        var selectedIndex = 0
        var dailyRoutineType: DailyRoutineType
    }

    enum Action {
        case nextButtonTapped
        case backButtonTapped
        case doneButtonTapped(date: Date, dailyRoutineType: DailyRoutineType)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                state.selectedIndex += 1
                return .none
            case .backButtonTapped:
                state.selectedIndex -= 1
                return .none
            case .doneButtonTapped(let date, let dailyRoutineType):
                @Dependency(\.dailyRoutineRepository.addDailyRoutine) var addDailyRoutine
                
                let dailyRoutineRecord = DailyRoutineRecord(
                    date: date,
                    dailyRoutineType: dailyRoutineType
                )

                do {
                    try addDailyRoutine(dailyRoutineRecord)
                } catch {
                    // 에러 처리
                }
                
                return .none
            }
        }
    }
}
