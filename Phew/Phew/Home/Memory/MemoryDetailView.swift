//
//  MemoryDetailView.swift
//  Phew
//
//  Created by dong eun shin on 5/6/25.
//

import ComposableArchitecture
import SwiftUI

struct MemoryDetailView: View {
    @Bindable var store: StoreOf<MemoryDetailFeature>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                if let data = store.firstImageData,
                   let uiImage = UIImage(data: data)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(12)
                }

                Text(store.state.memory.text)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    store.send(.closeButtonTapped)
                }) {
                    Image(systemName: "chevron.left")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        store.send(.editButtonTapped)
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }

                    Button(role: .destructive, action: {}) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Text("More")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
        .fullScreenCover(
            item: $store.scope(state: \.editMemory, action: \.showMemoryEditor)
        ) { store in
            MemoryEditorView(store: store)
        }
    }
}
