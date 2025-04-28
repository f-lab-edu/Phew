//
//  HomeViewModel.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import UIKit
import SwiftUI
import SwiftData

@Observable
final class HomeViewModel {
    var swipeDirection: UIPageViewController.NavigationDirection = .forward
    var selectedDate: Date = .now
    var currentWeekStartDate: Date = Date().startOfWeek()
    var currentMorningRoutine: DailyRoutineRecord?
    var currentNightRoutine: DailyRoutineRecord?
    
    private let calendar = Calendar.current

    func moveToPreviousWeek() {
        if let previousWeek = calendar.date(byAdding: .day, value: -7, to: currentWeekStartDate) {
            currentWeekStartDate = previousWeek
        }
    }

    func moveToNextWeek() {
        if let nextWeek = calendar.date(byAdding: .day, value: 7, to: currentWeekStartDate) {
            currentWeekStartDate = nextWeek
        }
    }
    
    func fetchRecord(dailyRoutineType: DailyRoutineType, context: ModelContext) {
        let id = DailyRoutineRecord.makeID(
            date: selectedDate,
            dailyRoutineType: .morning
        )
        let descriptor = FetchDescriptor<DailyRoutineRecord>(
            predicate: #Predicate { $0.id == id }
        )
        
        switch dailyRoutineType {
        case .morning:
            currentMorningRoutine = try? context.fetch(descriptor).first
        case .night:
            currentNightRoutine = try? context.fetch(descriptor).first
        }
    }
}
