//
//  CalenderView.swift
//  Phew
//
//  Created by dong eun shin on 4/18/25.
//

import SwiftUI
import HorizonCalendar

struct CalendarMainView: View {
    var body: some View {
        CalendarViewWrapper()
            .frame(height: 100)
            .padding()
        
        Text("CalendarView")
    }
}

import SwiftUI
import HorizonCalendar

//struct HorizonCalendarView: UIViewRepresentable {
//    typealias UIViewType = CalendarView
//    
//    private let initialContent: CalendarViewContent
//    
//    init(initialContent: CalendarViewContent) {
//        self.initialContent = initialContent
//    }
//    
//    func makeUIView(context: Context) -> HorizonCalendar.CalendarView {
//        return CalendarView(initialContent: initialContent)
//    }
//    
//    func updateUIView(_ uiView: HorizonCalendar.CalendarView, context: Context) {
//        
//    }
//}
