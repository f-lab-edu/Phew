//
//  EditMemoryFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/6/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct EditMemoryFeature {
    @ObservableState
    struct State: Equatable {
        var memory: Memory
        var firstImageData: Data? {
            memory.images?.first
        }
    }

    enum Action {
        case saveButtonTapped
        case closeButtonTapped
        case delegate(Delegate)
        
        enum Delegate {
            case save(Memory)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.memoryRepository.addMemory) var addMemory
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .saveButtonTapped:
                return .none
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            }
        }
    }
}
