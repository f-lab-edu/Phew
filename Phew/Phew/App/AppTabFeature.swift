//
//  AppTabFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/14/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppTabFeature {
    enum Tab {
        case home
        case status
        case account
    }

    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .home
        var home = HomeFeature.State()
        var status = StatusFeature.State()
    }

    enum Action {
        case selectTab(Tab)
        case home(HomeFeature.Action)
        case status(StatusFeature.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }

        Scope(state: \.status, action: \.status) {
            StatusFeature()
        }

        Reduce { state, action in
            switch action {
            case .selectTab(let tab):
                state.selectedTab = tab
                return .none
            default:
                return .none
            }
        }
    }
}
