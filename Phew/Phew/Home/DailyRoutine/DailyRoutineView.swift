//
//  DailyRoutineView.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import ComposableArchitecture

struct DailyRoutineView: View {
    @State private var localCurrentPage = 0
    
    @ObservedObject var viewStore: ViewStoreOf<DailyRoutineFeature>
    @Bindable var store: StoreOf<DailyRoutineFeature>

    init(store: StoreOf<DailyRoutineFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ZStack(alignment: .bottomTrailing) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(Array(store.state.tasks.enumerated()), id: \.offset) { index, task in
                                SingleSelectPage(
                                    question: task.title,
                                    items: store.state.emojis ?? [],
                                    selectedItem: Binding(
                                        get: { store.state.selectedItemsPerPage[index] },
                                        set: { store.send(.setSelectedItemsPerPage(index: index, selection: $0)) }
                                    )
                                )
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .id(index)
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .frame(height: geometry.size.height)
                    .onAppear {
                        store.send(.emojisLoaded)
                    }
                    .onChange(of: localCurrentPage) { oldValue, newValue in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            scrollProxy.scrollTo(newValue, anchor: .leading)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        nextButton()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func nextButton() -> some View {
        Button(action: {
            if localCurrentPage < store.state.tasks.count - 1 {
                localCurrentPage += 1
            } else {
                store.send(.doneButtonTapped)
            }
        }) {
            Image(systemName: localCurrentPage < store.state.tasks.count - 1 ? "chevron.right" : "checkmark")
                .padding(16)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding()
        }
    }
}

#Preview {
    DailyRoutineView(
        store: .init(
            initialState: DailyRoutineFeature.State.init(
                dailyRoutineType: .morning,
                selectedDate: .now
            ),
            reducer: {
                DailyRoutineFeature()
            }
        )
    )
}
