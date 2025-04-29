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
        
        func addDailyRoutineRecord(dailyRoutineRecord: DailyRoutineRecord) {
            print(";;;;;1111>>>>>>>>############", dailyRoutineRecord.dailyRoutineType)
            @Dependency(\.dailyRoutineRepository.addDailyRoutine) var addDailyRoutine
            
            do {
                print("+!> ", dailyRoutineRecord.dailyRoutineType)
                try addDailyRoutine(dailyRoutineRecord)
            } catch {
                print(">>>>>>RoutineFeature addDailyRoutineRecord 실패")
            }
        }
    }

    enum Action {
        case nextButtonTapped
        case backButtonTapped
        case doneButtonTapped(date: Date, dailyRoutineType: DailyRoutineType)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .nextButtonTapped:
            state.selectedIndex += 1
            return .none
        case .backButtonTapped:
            state.selectedIndex -= 1
            return .none
        case .doneButtonTapped(let date, let dailyRoutineType):
            let dailyRoutineRecord = DailyRoutineRecord(
                date: date,
                dailyRoutineType: dailyRoutineType
            )
            state.addDailyRoutineRecord(dailyRoutineRecord: dailyRoutineRecord)
            return .none
        }
    }
}
