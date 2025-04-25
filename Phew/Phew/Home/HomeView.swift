//
//  HomeView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    var body: some View {
        VStack {
            calendarHeaderView()
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
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
                .onAppear {
                    proxy.scrollTo(viewModel.currentIndex, anchor: .center)
                }
            }
            
            Spacer()
            
            SelectedDateDetailPageViewController(selectedDate: $viewModel.selectedDate)
                .frame(maxHeight: .infinity)
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = HomeViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
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
    
    @ViewBuilder
    private func calendarHeaderView() -> some View {
        HStack(spacing: 0) {
            Button {
                viewModel.scrollToPreviousWeek()
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Text(viewModel.selectedDate.monthAndDay())
                .font(.headline)
            
            Spacer()
            
            Button {
                viewModel.scrollToNextWeek()
            } label: {
                Image(systemName: "chevron.right")
            }
        }
    }
}

extension HomeView {
    @Observable
    final class HomeViewModel {
        var modelContext: ModelContext
        var weeks: [[Date]] = []
        var currentIndex: Int = 2
        var selectedDate: Date = .now {
            didSet {
                if let newIndex = indexForWeek(containing: selectedDate) {
                    currentIndex = newIndex
                }
            }
        }

        private let calendar = Calendar.current
        private let initialWeekOffset = 2
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            
            let today = Date()
            let baseStart = today.startOfWeek()

            weeks = (-initialWeekOffset...initialWeekOffset).map { offset in
                generateWeek(from: addWeeks(to: baseStart, by: offset))
            }
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
        
        private func indexForWeek(containing date: Date) -> Int? {
            for (i, week) in weeks.enumerated() {
                if week.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                    return i
                }
            }
            return nil
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: DailyRoutineLog.self)
    
    HomeView(modelContext: container.mainContext)
}
