import SwiftUI
import HorizonCalendar

struct CalendarMainView: View {
    @State private var selectedDate: Date? = nil
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

                RoutineButton(
                    icon: "star",
                    title: "저녘 루틴 레스고",
                    subtitle: "설명",
                    color: .green
                ) {
                    isPresenting = true
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
