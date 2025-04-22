import SwiftUI
import ComposableArchitecture
import HorizonCalendar

struct CalendarMainView: View {
    @State private var selectedDate: Date?
    @State private var isPresenting = false

    var body: some View {
        VStack(spacing: 0) {
            HorizonCalendarView(
                selectedDate: selectedDate,
                onDaySelection: { day in
                    let calendar = Calendar.current
                    if let newDate = calendar.date(from: day.components) {
                        selectedDate = newDate
                        print("Selected Date:", newDate)
                    }
                }
            )
            .frame(height: 400)
            .frame(maxWidth: .infinity)

            HStack(spacing: 0) {
                RoutineButton(
                    icon: "star",
                    title: "아침 루틴 레스고",
                    subtitle: "설명",
                    color: .blue
                ) {
                    isPresenting = true
                }
                .sheet(isPresented: $isPresenting) {
                    RoutineView(
                        store: Store(initialState: RoutineFeature.State(mode: .morning)) {
                        RoutineFeature()
                    }, routineList: [
                        Routine(title: "1", description: "1", imageName: "heart", responseType: .text),
                        Routine(title: "2", description: "2", imageName: "heart", responseType: .score),
                        Routine(title: "3", description: "3", imageName: "heart", responseType: .none)
                    ])
                }

                RoutineButton(
                    icon: "star",
                    title: "저녘 루틴 레스고",
                    subtitle: "설명",
                    color: .green
                ) {
                    isPresenting = true
                }
                .sheet(isPresented: $isPresenting) {
                    RoutineView(
                        store: Store(initialState: RoutineFeature.State(mode: .night)
                                    
                    ) {
                        RoutineFeature()
                    }, routineList: [
                        Routine(title: "1", description: "1", imageName: "heart", responseType: .text),
                        Routine(title: "2", description: "2", imageName: "heart", responseType: .score),
                        Routine(title: "3", description: "3", imageName: "heart", responseType: .none)
                    ])
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
