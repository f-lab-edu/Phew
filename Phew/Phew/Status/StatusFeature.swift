//
//  StatusFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/2/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct StatusFeature {
    @ObservableState
    struct State: Equatable {
        var score: Int = 50 // 임시 초기 점수
        var scale: CGFloat = 1.0
        var isGrowing: Bool = true
    }


    enum Action: Equatable {
        case startTimer
        case stopTimer
        case timerTicked
        case scoreChanged(Int)
    }
    
    private enum CancelID { case timer }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startTimer:
                return .run { send in
                    while true {
                        try await clock.sleep(for: .milliseconds(100))
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)
            case .stopTimer:
                return .cancel(id: CancelID.timer)
            case .timerTicked:
                if state.isGrowing {
                    state.scale += 0.02
                    if state.scale >= 1.1 {
                        state.isGrowing = false
                    }
                } else {
                    state.scale -= 0.02
                    if state.scale <= 0.9 {
                        state.isGrowing = true
                    }
                }
                return .none

            case let .scoreChanged(newScore):
                state.score = newScore
                return .none
            }
        }
    }
}
