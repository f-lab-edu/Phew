//
//  TaskDetailView.swift
//  Phew
//
//  Created by dong eun shin on 5/17/25.
//

import ComposableArchitecture
import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var viewStore: ViewStoreOf<TaskDetailFeature>
    var store: StoreOf<TaskDetailFeature>

    init(store: StoreOf<TaskDetailFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        VStack(spacing: 20) {
            Toggle("오늘의 루틴에 추가", isOn: viewStore.binding(
                get: \.isInTodayRoutine,
                send: TaskDetailFeature.Action.toggleTodayRoutine
            ))
            .onChange(of: viewStore.isInTodayRoutine) { oldValue, newValue in
                if !newValue {
                    viewStore.send(.toggleNotification(false))
                }
            }

            Divider()

            if viewStore.isInTodayRoutine {
                Toggle("알림 설정", isOn: viewStore.binding(
                    get: \.isNotificationEnabled,
                    send: TaskDetailFeature.Action.toggleNotification
                ))

                if viewStore.isNotificationEnabled {
                    DatePicker("알림 시간", selection: viewStore.binding(
                        get: \.notificationTime,
                        send: TaskDetailFeature.Action.updateNotificationTime
                    ), displayedComponents: .hourAndMinute)

                    Button("알림 예약하기") {
                        viewStore.send(.scheduleNotification)
                    }
                }
            }

            Spacer()
        }
        .navigationTitle(store.taskType.title)
        .padding()
        .alert(isPresented: viewStore.binding(
            get: \.showAlert,
            send: .alertDismissed
        )) {
            Alert(
                title: Text("알림"),
                message: Text(viewStore.alertMessage),
                dismissButton: .default(Text("확인"))
            )
        }
    }
}
