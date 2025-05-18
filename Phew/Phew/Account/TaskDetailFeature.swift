//
//  TaskDetailFeature.swift
//  Phew
//
//  Created by dong eun shin on 5/16/25.
//

import ComposableArchitecture
import UserNotifications
import Foundation
import Combine

@Reducer
struct TaskDetailFeature {
    @ObservableState
    struct State: Equatable {
        var taskType: TaskType
        var isInTodayRoutine: Bool = false
        var isNotificationEnabled: Bool = false
        var notificationTime: Date = Date()
        var showAlert: Bool = false
        var alertMessage: String = ""
    }

    enum Action: Equatable {
        case toggleTodayRoutine(Bool)
        case toggleNotification(Bool)
        case updateNotificationTime(Date)
        case requestNotificationPermission
        case notificationPermissionResponse(Bool)
        case scheduleNotification
        case notificationScheduled(Bool)
        case alertDismissed
    }

    @Dependency(\.taskDetailEnvironment) var taskDetailEnvironment

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleTodayRoutine(let isOn):
                state.isInTodayRoutine = isOn
                if !isOn {
                    state.isNotificationEnabled = false
                }
                return .none

            case .toggleNotification(let isOn):
                state.isNotificationEnabled = isOn
                if isOn {
                    return .run { send in await send(.requestNotificationPermission) }
                }
                return .none

            case .updateNotificationTime(let date):
                state.notificationTime = date
                return .none

            case .requestNotificationPermission:
                return .run { send in
                    do {
                        let granted = try await taskDetailEnvironment.requestAuthorization()
                        return await send(.notificationPermissionResponse(granted))
                    } catch {
                        return await send(.notificationPermissionResponse(false))
                    }
                }

            case .notificationPermissionResponse(let granted):
                if !granted {
                    state.isNotificationEnabled = false
                    state.alertMessage = "알림 권한이 거부되었습니다. 설정에서 권한을 허용해주세요."
                    state.showAlert = true
                }
                return .none

            case .scheduleNotification:
                return .run { [state] send in
                    do {
                        try await taskDetailEnvironment.scheduleNotification(state.notificationTime, state.taskType.title, state.taskType.body)
                        return await send(.notificationScheduled(true))
                    } catch {
                        return await send(.notificationScheduled(false))
                    }
                }

            case .notificationScheduled(let isSucceeded):
                state.alertMessage = isSucceeded ? "알림이 예약되었습니다." : "알림 예약 중 오류 발생"
                state.showAlert = true
                return .none

            case .alertDismissed:
                state.showAlert = false
                return .none
            }
        }
    }
}


extension DependencyValues {
   var taskDetailEnvironment: TaskDetailEnvironment {
       get { self[TaskDetailEnvironment.self] }
       set { self[TaskDetailEnvironment.self] = newValue }
   }
}

struct TaskDetailEnvironment {
    var requestAuthorization: @Sendable () async throws -> Bool
    var scheduleNotification: @Sendable (_ date: Date,_ title: String,_ body: String) async throws -> Void
}

extension TaskDetailEnvironment: DependencyKey {
    static var liveValue = TaskDetailEnvironment(
        requestAuthorization: {
            try await withCheckedThrowingContinuation { continuation in
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        switch settings.authorizationStatus {
                        case .notDetermined:
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                                if let error {
                                    continuation.resume(throwing: error)
                                } else {
                                    continuation.resume(returning: granted)
                                }
                            }
                        case .denied:
                            continuation.resume(returning: false)
                        case .authorized, .provisional, .ephemeral:
                            continuation.resume(returning: true)
                        @unknown default:
                            continuation.resume(returning: false)
                        }
                    }
                }
            }
        },
        scheduleNotification: { date, title, body in
            try await withCheckedThrowingContinuation { continuation in
                let content = UNMutableNotificationContent()
                content.title = "알림"
                content.body = body
                content.sound = .default

                var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
                dateComponents.second = 0

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }
        }
    )
}
