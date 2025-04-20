//
//  HorizonCalendarView.swift
//  Phew
//
//  Created by dong eun shin on 4/19/25.
//

import SwiftUI
import HorizonCalendar

struct HorizonCalendarView: UIViewRepresentable {    
    var selectedDate: Date?
    
    var onDaySelection: ((Day) -> Void)?

    func makeUIView(context: Context) -> CalendarView {
        let calendarView = CalendarView(initialContent: makeContent())
        
        calendarView.daySelectionHandler = { day in
            onDaySelection?(day)
        }
        
        calendarView.scroll(
            toDayContaining: Date(),
            scrollPosition: .lastFullyVisiblePosition,
            animated: false
        )
        
        return calendarView
    }

    func updateUIView(_ uiView: CalendarView, context: Context) {
        uiView.setContent(makeContent())
    }

    private func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current
        let today = Date()
        let year = calendar.component(.year, from: today)

        let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: year, month: 12, day: 31))!

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startOfYear...endOfYear,
            monthsLayout: .horizontal(options: .init())
        )
        .dayItemProvider { day in
            let date = calendar.date(from: day.components)
            let isSelected = date == selectedDate
            return SwiftUIDayView(dayNumber: day.day, isSelected: isSelected).calendarItemModel
        }
    }
}
