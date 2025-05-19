//
//  MeditationFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/18/25.
//

import ComposableArchitecture
import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Phew", category: "MeditationFeature")

@Reducer
struct MeditationFeature {
    @ObservableState
    struct State: Equatable {
        var selectedDate: Date
        var isPlaying: Bool = false
        var elapsedTime: TimeInterval = 0
    }
    
    enum Action: Equatable {
        case closeButtonTapped
        case playPauseTapped
        case timerTicked
        case updateMeditationSession
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.meditationEnvironment) var environment
    @Dependency(\.meditationSessionRepository.updateMeditationSession) var updateMeditationSession

    private enum CancelID { case timer }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .closeButtonTapped:
                state.isPlaying = false
                environment.audioPlayer.pause()
                return .run { send in
                    await send(.updateMeditationSession)
                    await self.dismiss()
                }

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
            case .updateMeditationSession:
                do {
                    try updateMeditationSession(state.selectedDate, state.elapsedTime)
                } catch {
                    logger.error("Failed to update meditation session:\(error.localizedDescription)")
                }
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
