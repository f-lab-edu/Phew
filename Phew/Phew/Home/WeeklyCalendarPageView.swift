//
//  WeeklyCalendarPageView.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI

struct WeeklyCalendarPageView: View {
    @Environment(HomeViewModel.self) var viewModel
    
    var week: [Date]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(week, id: \.self) { date in
                VStack {
                    Text(date.dayOfWeek())
                        .font(.caption)
                        .foregroundColor(.gray)
                                        
                    Text(date.dayOfMonth())
                        .frame(width: 40, height: 40)
                        .font(.title3)
                        .foregroundColor(
                            Calendar.current.isDateInToday(date)
                            ? .blue
                            : .primary
                        )
                        .background(
                            Circle()
                                .fill(
                                    Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                                    ? .green.opacity(0.5)
                                    : .gray.opacity(0.1)
                                )
                        )
                        .onTapGesture {
                            viewModel.selectedDate = date
                        }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}
