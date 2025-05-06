//
//  AddMemoryFeatures.swift
//  Phew
//
//  Created by dong eun shin on 5/4/25.
//

import SwiftUI
import ComposableArchitecture
import OSLog

private let logger = Logger(subsystem: "Phew", category: "AddMemoryFeatures")

@Reducer
struct AddMemoryFeatures {
    @ObservableState
    struct State: Equatable {
        var selectedDate: Date
    }

    enum Action {
        case saveButtonTapped(text: String, imageData: Data, isGoodMemory: Bool)
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
            case .saveButtonTapped(let text, let imageData, let isGoodMemory):
                return .run { [state] send in
                    let memory = Memory(
                        date: state.selectedDate,
                        text: text,
                        images: [imageData],
                        isGoodMemory: isGoodMemory
                    )

                    do {
                        try addMemory(memory)
                    } catch {
                        // TODO: - 에러 처리
                        logger.error("일기 데이터 저장 오류 발생: \(error.localizedDescription)")
                    }
                    
                    await send(.delegate(.save(memory)))
                    await self.dismiss()
                }
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            }
        }
    }
}
