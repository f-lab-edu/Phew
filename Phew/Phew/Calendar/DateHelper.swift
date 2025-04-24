//
//  DateHelper.swift
//  Phew
//
//  Created by dong eun shin on 4/24/25.
//

import SwiftUI

struct DateHelper {
    static func generateWeeks(startingFrom referenceDate: Date, weeksBefore: Int, weeksAfter: Int) -> [[Date]] {
        let calendar = Calendar.current
        var allWeeks: [[Date]] = []
        let startOfReferenceWeek = startOfWeek(for: referenceDate)

        for i in -weeksBefore...weeksAfter {
            if let weekStart = calendar.date(byAdding: .weekOfYear, value: i, to: startOfReferenceWeek) {
                let week = (0..<7).compactMap { day in
                    calendar.date(byAdding: .day, value: day, to: weekStart)
                }
                allWeeks.append(week)
            }
        }
        return allWeeks
    }
    
    static func startOfWeek(for date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
    }

    static func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
