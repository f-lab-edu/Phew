//
//  EditDailyRoutineFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/6/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditDailyRoutineFeature {
    @ObservableState
    struct State: Equatable {
        var record: DailyRoutineRecord
    }

    enum Action {
        case closeButtonTapped
        case delegate(Delegate)

        enum Delegate {
            case save(DailyRoutineRecord)
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { _, action in
            switch action {
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            }
        }
    }
}
