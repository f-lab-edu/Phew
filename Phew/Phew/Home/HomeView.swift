//
//  HomeView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.scrollToPreviousWeek()
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Button {
                    viewModel.scrollToNextWeek()
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(viewModel.weeks.indices, id: \.self) { index in
                            weekView(for: viewModel.weeks[index])
                                .id(index)
                        }
                    }
                }
                .frame(height: 80)
                .scrollTargetBehavior(.paging)
                .onChange(of: viewModel.currentIndex) { oldValue, newValue in
                    withAnimation {
                        print(newValue, oldValue)
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
                .onAppear {
                    proxy.scrollTo(viewModel.currentIndex, anchor: .center)
                }
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func weekView(for week: [Date]) -> some View {
        HStack(spacing: 0) {
            ForEach(week, id: \.self) { date in
                VStack {
                    Text(date.dayOfWeek())
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(2)
                    
                    Text(date.dayOfMonth())
                        .font(.title3)
                        .foregroundColor(Calendar.current.isDateInToday(date) ? .blue : .primary)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(
                                    Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                                    ? Color.green
                                    : Color.gray.opacity(0.2)
                                )
                        )
                        .onTapGesture {
                            viewModel.selectedDate = date
                        }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

extension HomeView {
    @Observable
    final class HomeViewModel {
        var weeks: [[Date]] = []
        var currentIndex: Int = 2
        var selectedDate: Date = .now

        private let calendar = Calendar.current
        private let initialWeekOffset = 2
        
        init() {
            let today = Date()
            let baseStart = today.startOfWeek()

            weeks = (-initialWeekOffset...initialWeekOffset).map { offset in
                generateWeek(from: addWeeks(to: baseStart, by: offset))
            }

            currentIndex = initialWeekOffset
        }

        func scrollToPreviousWeek() {
            if currentIndex - 1 < initialWeekOffset {
                prependWeeks()
            }
            
            currentIndex -= 1
        }

        func scrollToNextWeek() {
            if currentIndex + 1 > weeks.count - 3 {
                appendWeeks()
            }
            
            currentIndex += 1
        }
        
        private func prependWeeks() {
            guard let firstDate = weeks.first?.first else { return }

            let newWeeks = generateWeek(from: addWeeks(to: firstDate, by: -1))

            weeks.insert(newWeeks, at: 0)
            
            currentIndex += 1
        }

        private func appendWeeks() {
            guard let lastDate = weeks.last?.first else { return }

            let newWeeks = generateWeek(from: addWeeks(to: lastDate, by: 1))

            weeks.append(newWeeks)
        }

        private func generateWeek(from startDate: Date) -> [Date] {
            (0..<7).compactMap {
                calendar.date(byAdding: .day, value: $0, to: startDate)
            }
        }

        private func addWeeks(to startDate: Date, by offset: Int) -> Date {
            calendar.date(byAdding: .weekOfYear, value: offset, to: startDate)!
        }
    }
}

#Preview {
    HomeView()
}
