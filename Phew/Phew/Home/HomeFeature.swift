//
//  HomeFeature.swift
//  Phew
//
//  Created by dong eun shin on 4/29/25.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var selectedDate: Date = .now
        var morningDailyRoutineRecord: DailyRoutineRecord?
        var nightDailyRoutineRecord: DailyRoutineRecord?
        
        var swipeDirection: UIPageViewController.NavigationDirection = .forward
        var currentWeekStartDate: Date = Date().startOfWeek()
        
        mutating func fetchDailyRoutineRecord(dailyRoutineType: DailyRoutineType) -> DailyRoutineRecord? {
            @Dependency(\.dailyRoutineRepository.fetchDailyRoutine) var fetchDailyRoutine
            
            do {
                return try fetchDailyRoutine(selectedDate, dailyRoutineType)
            } catch {
                return nil
            }
        }
        
        mutating func moveToPreviousWeek() {
            if let previousWeek = Calendar.current.date(byAdding: .day, value: -7, to: currentWeekStartDate) {
                currentWeekStartDate = previousWeek
            }
        }

        mutating func moveToNextWeek() {
            if let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: currentWeekStartDate) {
                currentWeekStartDate = nextWeek
            }
        }
    }

    enum Action {
        case fetchSelectedDateDailyRoutineRecord
        case moveToPreviousWeek
        case moveToNextWeek
        case selectedDate(Date)
        case setCurrentWeekStartDate(Date)
        case setSwipeDirection(UIPageViewController.NavigationDirection)
    }
        
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchSelectedDateDailyRoutineRecord:
            state.morningDailyRoutineRecord = state.fetchDailyRoutineRecord(dailyRoutineType: .morning)
            state.nightDailyRoutineRecord = state.fetchDailyRoutineRecord(dailyRoutineType: .night)
            return .none
        case .moveToPreviousWeek:
            state.moveToPreviousWeek()
            return .none
        case .moveToNextWeek:
            state.moveToNextWeek()
            return .none
        case .selectedDate(let date):
            state.selectedDate = date
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
