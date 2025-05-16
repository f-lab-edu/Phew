//
//  Date+.swift
//  Phew
//
//  Created by dong eun shin on 4/25/25.
//

import Foundation

extension Date {
    func startOfWeek() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    func dayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "E"
        return formatter.string(from: self)
    }

    func dayOfMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }

    func monthAndDay() -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }

    func generateWeek() -> [Date] {
        (0 ..< 7).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: self)
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
