//
//  MeditationFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/18/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MeditationFeature {
    @ObservableState
    struct State: Equatable {
        var isPlaying: Bool = false
        var elapsedTime: TimeInterval = 0
    }

    enum Action: Equatable {
        case closeButtonTapped
        case playPauseTapped
        case timerTicked
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.meditationEnvironment) var environment

    private enum CancelID { case timer }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .closeButtonTapped:
                state.isPlaying = false
                environment.audioPlayer.pause()
                return .run { _ in await self.dismiss() }

            case .playPauseTapped:
                state.isPlaying.toggle()

                if state.isPlaying {
                    return startPlaying()
                } else {
                    return stopPlaying()
                }

            case .timerTicked:
                guard state.isPlaying else { return .none }

                state.elapsedTime += 0.02
                
                return .none
            }
        }
    }

    private func startPlaying() -> Effect<Action> {
        return .run { _ in
            environment.audioPlayer.play()
        }
    }

    private func stopPlaying() -> Effect<Action> {
        return .run { _ in
            environment.audioPlayer.pause()
        }
    }
}
