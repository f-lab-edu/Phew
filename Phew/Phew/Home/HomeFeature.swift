//
//  HomeFeature.swift
//  Phew
//
//  Created by dong eun shin on 4/29/25.
//

import ComposableArchitecture
import Dependencies
import OSLog
import SwiftUI

private let logger = Logger(subsystem: "Phew", category: "HomeFeature")

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var addRoutine: DailyRoutineFeature.State?
        @Presents var addMemory: MemoryEditorFeatures.State?
        @Presents var memoryDetail: MemoryDetailFeature.State?
        @Presents var routineDetail: EditDailyRoutineFeature.State?
        @Presents var meditation: MeditationFeature.State?

        var selectedDate: Date = .now
        var morningDailyRoutineRecord: DailyRoutineRecord?
        var nightDailyRoutineRecord: DailyRoutineRecord?

        var swipeDirection: UIPageViewController.NavigationDirection = .forward
        var currentWeekStartDate: Date = Date().startOfWeek()

        var morningDailyRoutineCache: [String: DailyRoutineRecord] = [:]
        var nightDailyRoutineCache: [String: DailyRoutineRecord] = [:]

        var selectedDateMemory: Memory? {
            didSet {
                guard let date = selectedDateMemory?.date.monthAndDay() else { return }
                memoryCache[date] = selectedDateMemory
            }
        }

        var memoryCache: [String: Memory] = [:]
    }

    enum Action {
        case selectedDate(Date)
        case setCurrentWeekStartDate(Date)
        case fetchMemory
        case moveToPreviousWeek
        case moveToNextWeek
        case setSwipeDirection(UIPageViewController.NavigationDirection)
        case fetchSelectedDateDailyRoutineRecord

        case addMorningRoutineButtonTapped
        case addNightRoutineButtonTapped
        case savedMemoryButtonTapped
        case meditationButtonTapped
        case addMemoryButtonTapped
        case routineDetailButtonTapped(dailyRoutineType: DailyRoutineType)

        case addRoutine(PresentationAction<DailyRoutineFeature.Action>)
        case showRoutineDetail(PresentationAction<EditDailyRoutineFeature.Action>)
        case addMemory(PresentationAction<MemoryEditorFeatures.Action>)
        case showMemoryDetail(PresentationAction<MemoryDetailFeature.Action>)
        case showMeditationView(PresentationAction<MeditationFeature.Action>)
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
                        // TODO: - 에러 처리
                        logger.error("아침 루틴 데이터 불러오기 오류 발생: \(error.localizedDescription)")
                    }
                }

                if let cachedNightRecord = state.nightDailyRoutineCache[selectedDate.monthAndDay()] {
                    state.nightDailyRoutineRecord = cachedNightRecord
                } else {
                    do {
                        state.nightDailyRoutineRecord = try fetchDailyRoutine(selectedDate, .night)
                        state.nightDailyRoutineCache[selectedDate.monthAndDay()] = state.nightDailyRoutineRecord
                    } catch {
                        // TODO: - 에러 처리
                        logger.error("저녘 루틴 데이터 불러오기 오류 발생: \(error.localizedDescription)")
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
            case let .selectedDate(date):
                state.selectedDate = date
                logger.debug("Selected Date: \(date.monthAndDay())")
                return .none
            case let .setCurrentWeekStartDate(date):
                state.currentWeekStartDate = date
                return .none
            case let .setSwipeDirection(direction):
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
            case let .addRoutine(.presented(.delegate(.save(record)))):
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
                state.addMemory = MemoryEditorFeatures.State(
                    selectedDate: state.selectedDate,
                    mode: .add
                )
                return .none
            case let .addMemory(.presented(.delegate(.save(memory)))):
                state.selectedDateMemory = memory
                return .none
            case .fetchMemory:
                let selectedDate = state.selectedDate

                if let cachedMemory = state.memoryCache[selectedDate.monthAndDay()] {
                    state.selectedDateMemory = cachedMemory
                } else {
                    do {
                        state.selectedDateMemory = try fetchMemory(selectedDate)
                    } catch {
                        // TODO: - 에러 처리
                        logger.error("일기 데이터 불러오기 오류 발생: \(error.localizedDescription)")
                    }
                }

                return .none
            case .savedMemoryButtonTapped:
                guard
                    let selectedDateMemory = state.selectedDateMemory
                else {
                    return .none
                }

                state.memoryDetail = MemoryDetailFeature.State(memory: selectedDateMemory)

                return .none
            case let .routineDetailButtonTapped(dailyRoutineType):
                if let record = dailyRoutineType == .morning ? state.morningDailyRoutineRecord : state.nightDailyRoutineRecord {
                    state.routineDetail = EditDailyRoutineFeature.State(record: record)
                }
                return .none
            case let .showMemoryDetail(.presented(.delegate(.update(memory)))):
                state.selectedDateMemory = memory
                return .none
            case .meditationButtonTapped:
                state.meditation = MeditationFeature.State()
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$addRoutine, action: \.addRoutine) {
            DailyRoutineFeature()
        }
        .ifLet(\.$addMemory, action: \.addMemory) {
            MemoryEditorFeatures()
        }
        .ifLet(\.$memoryDetail, action: \.showMemoryDetail) {
            MemoryDetailFeature()
        }
        .ifLet(\.$routineDetail, action: \.showRoutineDetail) {
            EditDailyRoutineFeature()
        }
        .ifLet(\.$meditation, action: \.showMeditationView) {
            MeditationFeature()
        }
    }
}
