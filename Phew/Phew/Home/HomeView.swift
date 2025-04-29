//
//  HomeView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { store in
            VStack {
                calendarHeaderView(selectedDate: store.state.selectedDate.monthAndDay())
                    .padding(.horizontal)
                
                WeeklyCalendarPageViewController(store: self.store)
                    .frame(maxHeight: 80)
                
                SelectedDateDetailPageViewController(store: self.store)
                    .frame(maxHeight: .infinity)
            }
        }
    }
    
    @ViewBuilder
    private func calendarHeaderView(selectedDate: String) -> some View {
        HStack(alignment: .center) {
            Text(selectedDate)
                .font(.headline)
        }
    }
}

#Preview {
    HomeView(store:
                Store(initialState:
                        HomeFeature.State.init(
                            selectedDate: .now,
                            morningDailyRoutineRecord: nil,
                            nightDailyRoutineRecord: nil),
                      reducer: { HomeFeature() }
                     )
    )
    .environment(HomeViewModel())
}
