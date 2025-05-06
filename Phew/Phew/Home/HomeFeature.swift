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
        @Presents var addRoutine: DailyRoutineFeature.State?
        @Presents var addMemory: AddMemoryFeatures.State?
        @Presents var editMemory: EditMemoryFeature.State?
        @Presents var editRoutine: EditDailyRoutineFeature.State?
        
        var selectedDate: Date = .now
        var morningDailyRoutineRecord: DailyRoutineRecord?
        var nightDailyRoutineRecord: DailyRoutineRecord?
        
        var swipeDirection: UIPageViewController.NavigationDirection = .forward
        var currentWeekStartDate: Date = Date().startOfWeek()
        
        var morningDailyRoutineCache: [String: DailyRoutineRecord] = [:]
        var nightDailyRoutineCache: [String: DailyRoutineRecord] = [:]
        
        var selectedDateMemory: Memory?
        var memoryCache: [String: Memory] = [:]
    }

    enum Action {
        case selectedDate(Date)
        case setCurrentWeekStartDate(Date)
        
        case moveToPreviousWeek
        case moveToNextWeek
        case setSwipeDirection(UIPageViewController.NavigationDirection)
        
        case fetchSelectedDateDailyRoutineRecord
        case addMorningRoutineButtonTapped
        case addNightRoutineButtonTapped
        case addRoutine(PresentationAction<DailyRoutineFeature.Action>)
        case editRoutine(PresentationAction<EditDailyRoutineFeature.Action>)
        case editRoutineButtonTapped(dailyRoutineType: DailyRoutineType)
        
        case addMemory(PresentationAction<AddMemoryFeatures.Action>)
        case addMemoryButtonTapped
        case fetchMemory
        case savedMemoryButtonTapped
        case editMemory(PresentationAction<EditMemoryFeature.Action>)
    }
    
    @Dependency(\.dailyRoutineRepository.fetchDailyRoutine) var fetchDailyRoutine
    @Dependency(\.memoryRepository.fetchMemory) var fetchMemory

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchSelectedDateDailyRoutineRecord:
                let selectedDate = state.selectedDate

                if let cachedchedMorningRecord = state.morningDailyRoutineCache[selectedDate.monthAndDay()] {
                    state.morningDailyRoutineRecord = cachedchedMorningRecord
                } else {
                    do {
                        state.morningDailyRoutineRecord = try fetchDailyRoutine(selectedDate, .morning)
                        state.morningDailyRoutineCache[selectedDate.monthAndDay()] = state.morningDailyRoutineRecord
                    } catch {
                        // 에러 처리
                    }
                }

                if let cachedNightRecord = state.nightDailyRoutineCache[selectedDate.monthAndDay()] {
                    state.nightDailyRoutineRecord = cachedNightRecord
                } else {
                    do {
                        state.nightDailyRoutineRecord = try fetchDailyRoutine(selectedDate, .night)
                        state.nightDailyRoutineCache[selectedDate.monthAndDay()] = state.nightDailyRoutineRecord
                    } catch {
                        // 에러 처리
                    }
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
                logger.debug("Selected Date: \(date.monthAndDay())")
                return .none
            case .setCurrentWeekStartDate(let date):
                state.currentWeekStartDate = date
                return .none
            case .setSwipeDirection(let direction):
                state.swipeDirection = direction
                return .none
            case .addMorningRoutineButtonTapped:
                state.addRoutine = DailyRoutineFeature.State(
                    dailyRoutineType: .morning,
                    selectedDate: state.selectedDate
                )
                return .none
            case .addNightRoutineButtonTapped:
                state.addRoutine = DailyRoutineFeature.State(
                    dailyRoutineType: .night,
                    selectedDate: state.selectedDate
                )
                return .none
            case .addRoutine(.presented(.delegate(.save(let record)))):
                if record.dailyRoutineType == .morning {
                    state.morningDailyRoutineRecord = record
                    state.morningDailyRoutineCache[record.date.monthAndDay()] = record
                } else {
                    state.nightDailyRoutineRecord = record
                    state.nightDailyRoutineCache[record.date.monthAndDay()] = record
                }
                return .none
            case .addRoutine:
                return .none
            case .addMemoryButtonTapped:
                state.addMemory = AddMemoryFeatures.State(selectedDate: state.selectedDate)
                return .none
            case .addMemory(.presented(.delegate(.save(let memory)))):
                state.selectedDateMemory = memory
                return .none
            case .fetchMemory:
                let selectedDate = state.selectedDate

                if let cachedMemory = state.memoryCache[selectedDate.monthAndDay()] {
                    state.selectedDateMemory = cachedMemory
                } else {
                    do {
                        state.selectedDateMemory = try fetchMemory(selectedDate)
                        state.memoryCache[selectedDate.monthAndDay()] = state.selectedDateMemory
                    } catch {
                        // 에러 처리
                    }
                }
                
                return .none
            case .savedMemoryButtonTapped:
                guard
                    let selectedDateMemory = state.selectedDateMemory
                else {
                    return .none
                }
                
                state.editMemory = EditMemoryFeature.State(memory: selectedDateMemory)
                
                return .none
            case .editRoutineButtonTapped(let dailyRoutineType):
                if let record = dailyRoutineType == .morning ? state.morningDailyRoutineRecord : state.nightDailyRoutineRecord {
                    state.editRoutine = EditDailyRoutineFeature.State(record: record)
                }
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$addRoutine, action: \.addRoutine) {
            DailyRoutineFeature()
        }
        .ifLet(\.$addMemory, action: \.addMemory) {
            AddMemoryFeatures()
        }
        .ifLet(\.$editMemory, action: \.editMemory) {
            EditMemoryFeature()
        }
        .ifLet(\.$editRoutine, action: \.editRoutine) {
            EditDailyRoutineFeature()
        }
    }
}
