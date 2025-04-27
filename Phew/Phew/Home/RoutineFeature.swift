//
//  RoutineFeature.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

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
        case doneButtonTapped(answer: String)
    }
    
    @Environment(\.modelContext) var modelContext

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .nextButtonTapped:
            state.selectedIndex += 1
            return .none
        case .backButtonTapped:
            state.selectedIndex -= 1
            return .none
        case .doneButtonTapped(let answer):
//            let routineLog = RoutineLog(date: Date(), text: answer)
//            modelContext.insert(routineLog)
            return .none
        }
    }
}
