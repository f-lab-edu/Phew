import SwiftUI
import HorizonCalendar

struct CalendarMainView: View {
    @State private var selectedDate: Date? = nil

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
                Button("아침 루틴") {
                    print("왼쪽 버튼 탭")
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)

                Button("저녘 루틴") {
                    print("오른쪽 버튼 탭")
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
