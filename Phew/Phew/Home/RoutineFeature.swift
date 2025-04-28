//
//  RoutineFeature.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import SwiftData
import ComposableArchitecture
import Dependencies

@Reducer
struct RoutineFeature {
    @ObservableState
    struct State {
        var selectedIndex = 0
        var mode: State.Mode
        
        
        enum Mode: Equatable {
            case morning
            case night
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
            // 루틴 데이터 저장 로직
            return .none
        }
    }
}
