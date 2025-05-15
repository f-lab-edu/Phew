//
//  StatusFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/2/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct StatusFeature {
    @ObservableState
    struct State: Equatable {
        var score: Int = 50 // 임시 초기 점수
    }

    enum Action: Equatable {
        case scoreChanged(Int)
    }

    private enum CancelID { case timer }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .scoreChanged(newScore):
                state.score = newScore
                return .none
            }
        }
    }
}
