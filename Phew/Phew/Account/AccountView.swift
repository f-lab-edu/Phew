//
//  AccountView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import ComposableArchitecture
import SwiftUI

struct AccountView: View {
    @ObservedObject var viewStore: ViewStoreOf<AccountFeature>
    var store: StoreOf<AccountFeature>

    init(store: StoreOf<AccountFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        NavigationStack {
            List(store.tasks, id: \.self) { task in
                NavigationLink(value: task) {
                    Text(task.type.title)
                        .onTapGesture {
                            viewStore.send(.selectTask(task))
                        }
                }
            }
            .navigationTitle("My Daily Routine")
            .navigationDestination(for: TaskItem.self) { task in
                TaskDetailView(store: .init(initialState: TaskDetailFeature.State.init(taskType: task.type), reducer: {
                    TaskDetailFeature()
                }))
//                IfLetStore(
//                    store.scope(
//                        state: \.taskDetail,
//                        action: \.taskDetail
//                    )
//                ) { scopedStore in
//                    TaskDetailView(store: scopedStore)
//                }
            }
        }
    }}

#Preview {
    AccountView(store: .init(initialState: AccountFeature.State.init(), reducer: {
        AccountFeature()
    }))
}
