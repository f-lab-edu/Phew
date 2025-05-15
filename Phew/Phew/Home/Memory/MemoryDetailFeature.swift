//
//  MemoryDetailFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/6/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MemoryDetailFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var editMemory: MemoryEditorFeatures.State?
        var memory: Memory
        var firstImageData: Data? {
            memory.images?.first
        }
    }

    enum Action {
        case saveButtonTapped
        case closeButtonTapped
        case editButtonTapped
        case delegate(Delegate)
        case showMemoryEditor(PresentationAction<MemoryEditorFeatures.Action>)

        enum Delegate {
            case update(Memory)
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
                return .run { [state] send in
                    await send(.delegate(.update(state.memory)))
                    await self.dismiss()
                }
            case .delegate:
                return .none
            case .editButtonTapped:
                state.editMemory = MemoryEditorFeatures.State(
                    selectedDate: state.memory.date,
                    memory: state.memory,
                    mode: .edit
                )
                return .none
            case let .showMemoryEditor(.presented(.delegate(.save(memory)))):
                state.memory = memory
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$editMemory, action: \.showMemoryEditor) {
            MemoryEditorFeatures()
        }
    }
}
