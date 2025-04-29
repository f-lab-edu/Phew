//
//  WeeklyCalendarPageView.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import ComposableArchitecture

struct WeeklyCalendarPageView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var week: [Date]

    var body: some View {
        WithViewStore(store, observe: { $0 }) { store in
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
                                        Calendar.current.isDate(date, inSameDayAs: store.state.selectedDate)
                                        ? .green.opacity(0.5)
                                        : .gray.opacity(0.1)
                                    )
                            )
                            .onTapGesture {
                                store.send(.selectedDate(date))
                            }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}
