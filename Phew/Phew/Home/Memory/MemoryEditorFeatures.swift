//
//  MemoryEditorFeatures.swift
//  Phew
//
//  Created by dong eun shin on 5/4/25.
//

import ComposableArchitecture
import OSLog
import PhotosUI
import SwiftUI

private let logger = Logger(subsystem: "Phew", category: "AddMemoryFeatures")

enum MemoryEmotion: String, CaseIterable, Identifiable {
    case remember
    case forget

    var id: String { rawValue }

    var description: String {
        switch self {
        case .remember: return "Keep it in my heart"
        case .forget: return "Let it fade away"
        }
    }
}

@Reducer
struct MemoryEditorFeatures {
    @ObservableState
    struct State: Equatable {
        var mode: Mode
        var selectedDate: Date
        var text: String
        var isGoodMemory: MemoryEmotion
        var selectedImage: UIImage?
        var selectedItem: PhotosPickerItem?
        var memory: Memory?

        var isSaveButtonDisabled: Bool {
            text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        enum Mode {
            case add
            case edit
        }

        init(selectedDate: Date, memory: Memory? = nil, mode: Mode) {
            self.selectedDate = selectedDate
            self.memory = memory
            text = memory?.text ?? ""
            self.mode = mode
            isGoodMemory = (memory?.isGoodMemory ?? true) ? .remember : .forget

            if let imageData = memory?.images?.first,
               let image = UIImage(data: imageData)
            {
                selectedImage = image
            }
        }
    }

    enum Action {
        case saveButtonTapped
        case closeButtonTapped
        case delegate(Delegate)
        case textChanged(String)
        case isGoodMemoryChanged(MemoryEmotion)
        case selectedImageChanged(UIImage?)
        case selectedItemChanged(PhotosPickerItem?)

        enum Delegate {
            case save(Memory)
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.memoryRepository) var memoryRepository

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .saveButtonTapped:
                return .run { [state] send in
                    let imageData = state.selectedImage?.jpegData(compressionQuality: 0.8)

                    let memory = Memory(
                        date: state.selectedDate,
                        text: state.text,
                        images: imageData != nil ? [imageData!] : nil,
                        isGoodMemory: state.isGoodMemory == .remember ? true : false
                    )

                    do {
                        if state.mode == .add {
                            try memoryRepository.addMemory(memory)
                        } else {
                            try memoryRepository.updateMemory(memory)
                        }
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
            case let .textChanged(newText):
                state.text = newText
                return .none
            case let .isGoodMemoryChanged(isGoodMemory):
                state.isGoodMemory = isGoodMemory
                return .none
            case let .selectedImageChanged(image):
                state.selectedImage = image
                return .none
            case let .selectedItemChanged(item):
                state.selectedItem = item
                return .none
            }
        }
    }
}
