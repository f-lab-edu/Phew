//
//  MemoryEditorView.swift
//  Phew
//
//  Created by dong eun shin on 5/4/25.
//

import SwiftUI
import PhotosUI
import PhewComponent
import ComposableArchitecture

struct MemoryEditorView: View {
    let store: StoreOf<MemoryEditorFeatures>
    @ObservedObject var viewStore: ViewStoreOf<MemoryEditorFeatures>
    
    init(store: StoreOf<MemoryEditorFeatures>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    CloseButton {
                        store.send(.closeButtonTapped)
                    }
                }
                
                Text("Question")
                    .font(.title2)
                
                selectedImageWithCloseButton()
                
                textEditorWithPlaceholder()
                
                Picker(
                    "How would you like to keep this memory?",
                    selection: viewStore.binding(
                        get: \.isGoodMemory,
                        send: MemoryEditorFeatures.Action.isGoodMemoryChanged
                    )
                ) {
                    ForEach(MemoryEmotion.allCases) { emotion in
                        Text(emotion.description).tag(emotion)
                    }
                }
                .pickerStyle(.segmented)
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .ignoresSafeArea(.keyboard)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            footerView()
                .padding()
                .cornerRadius(16)
        }
        .onChange(of: viewStore.selectedItem) { oldItem, newItem in
            if let newItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        store.send(.selectedImageChanged(uiImage))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func footerView() -> some View {
        HStack(spacing: 20) {
            photosPicker()
            
            Spacer()
            
            saveButton
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
    }
    
    @ViewBuilder
    private func selectedImageWithCloseButton() -> some View {
        if let image = store.selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(12)
                .overlay(alignment: .topTrailing) {
                    Button {
                        store.send(.selectedImageChanged(nil))
                        store.send(.selectedImageChanged(nil))
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .bold))
                            .padding(8)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: store.selectedImage)
        }
    }
    
    @ViewBuilder
    private func textEditorWithPlaceholder() -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text:
                viewStore.binding(
                    get: \.text,
                    send: MemoryEditorFeatures.Action.textChanged
                )
            )
            .background(Color.clear)
            
            if store.text.isEmpty {
                Text("Type here...")
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.leading, 5)
            }
        }
        .frame(height: 150)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
    }
    
    @ViewBuilder
    private func photosPicker() -> some View {
        PhotosPicker(
            selection: viewStore.binding(
                get: \.selectedItem,
                send: MemoryEditorFeatures.Action.selectedItemChanged
            ),
            matching: .images,
            photoLibrary: .shared()
        ) {
            Image(systemName: "photo")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(.green)
                .clipShape(Circle())
                .shadow(radius: 4)
        }

    }
    
    private var saveButton: some View {
        Button {
            store.send(.saveButtonTapped)
        } label: {
            Image(systemName: "checkmark")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(viewStore.isSaveButtonDisabled ? .gray.opacity(0.5) : .green)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .disabled(viewStore.isSaveButtonDisabled)
    }
}

#Preview {
    MemoryEditorView(
        store: .init(
            initialState: MemoryEditorFeatures.State.init(selectedDate: .now, mode: .add),
            reducer: {
                MemoryEditorFeatures()
            }
        )
    )
}
