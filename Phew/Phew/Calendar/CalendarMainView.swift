//
//  CalendarMainView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI

struct CalendarMainView: View {
    @State private var selectedDate: Date = Date()
    
    let weekdays = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    let weeks: [[Date]]

    init() {
        self.weeks = DateHelper.generateWeeks(startingFrom: Date(), weeksBefore: 1, weeksAfter: 12)
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 12) {
                    ForEach(0..<7, id: \.self) { index in
                        Text(weekdays[index])
                            .font(.caption)
                            .frame(width: 40)
                            .foregroundColor(.gray)
                    }
                }
                
                GeometryReader { geometry in
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 0) {
                                ForEach(Array(weeks.enumerated()), id: \.element) { index, week in
                                    HStack(spacing: 12) {
                                        ForEach(week, id: \.self) { date in
                                            Text(DateHelper.dayString(from: date))
                                                .frame(width: 40, height: 40)
                                                .background(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.green : Color.gray.opacity(0.2))
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    selectedDate = date
                                                }
                                        }
                                    }
                                    .frame(width: geometry.size.width)
                                    .id(index)
                                }
                            }
                        }
                        .scrollTargetBehavior(.paging)
                        .onAppear {
                            proxy.scrollTo(1, anchor: .leading)
                        }
                    }
                }
                .frame(height: 40)
                
                Spacer()
            }
        }
    }
}


#Preview {
    CalendarMainView()
}
