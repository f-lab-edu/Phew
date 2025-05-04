//
//  AddMemoryFeatures.swift
//  Phew
//
//  Created by dong eun shin on 5/4/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AddMemoryFeatures {
    @ObservableState
    struct State: Equatable {
        var selectedDate: Date
    }

    enum Action {
        case saveButtonTapped(String)
        case closeButtonTapped
        case delegate(Delegate)
        
        enum Delegate {
            case save(DailyRoutineRecord)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .saveButtonTapped(let text):
                return .none
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            }
        }
    }
}
