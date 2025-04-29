//
//  HomeFeature.swift
//  Phew
//
//  Created by dong eun shin on 4/29/25.
//

import SwiftUI
import ComposableArchitecture
import Dependencies
import OSLog

private let logger = Logger(subsystem: "Phew", category: "HomeFeature")

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var selectedDate: Date = .now
        var morningDailyRoutineRecord: DailyRoutineRecord?
        var nightDailyRoutineRecord: DailyRoutineRecord?
        
        var swipeDirection: UIPageViewController.NavigationDirection = .forward
        var currentWeekStartDate: Date = Date().startOfWeek()
    }

    enum Action {
        case fetchSelectedDateDailyRoutineRecord
        case moveToPreviousWeek
        case moveToNextWeek
        case selectedDate(Date)
        case setCurrentWeekStartDate(Date)
        case setSwipeDirection(UIPageViewController.NavigationDirection)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchSelectedDateDailyRoutineRecord:
                @Dependency(\.dailyRoutineRepository.fetchDailyRoutine) var fetchDailyRoutine
                
                do {
                    state.morningDailyRoutineRecord = try fetchDailyRoutine(state.selectedDate, .morning)
                    state.nightDailyRoutineRecord = try fetchDailyRoutine(state.selectedDate, .night)
                } catch {
                    // 에러 처리
                }
                return .none
            case .moveToPreviousWeek:
                if let previousWeek = Calendar.current.date(byAdding: .day, value: -7, to: state.currentWeekStartDate) {
                    state.currentWeekStartDate = previousWeek
                }
                return .none
            case .moveToNextWeek:
                if let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: state.currentWeekStartDate) {
                    state.currentWeekStartDate = nextWeek
                }
                return .none
            case .selectedDate(let date):
                state.selectedDate = date
                logger.debug("Selected Date: \(date)")
                return .none
            case .setCurrentWeekStartDate(let date):
                state.currentWeekStartDate = date
                return .none
            case .setSwipeDirection(let direction):
                state.swipeDirection = direction
                return .none
            }
        }
    }
}
