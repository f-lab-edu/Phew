//
//  HomeViewModel.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import UIKit
import SwiftUI

@Observable
final class HomeViewModel {
    var swipeDirection: UIPageViewController.NavigationDirection = .forward
    var selectedDate: Date = .now
    var currentWeekStartDate: Date = Date().startOfWeek()
    
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
}
