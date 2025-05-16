//
//  AppFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/13/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @Reducer(state: .equatable)
    public enum Destination {

    }

    @ObservableState
    struct State: Equatable {
        @Presents public var destination: Destination.State?
        var appTab: AppTabFeature.State = .init()
    }

    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case appTab(AppTabFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.appTab, action: \.appTab) {
            AppTabFeature()
        }

        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination.body
        }
    }
}
