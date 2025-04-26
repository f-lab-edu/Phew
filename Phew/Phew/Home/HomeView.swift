//
//  HomeView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(HomeViewModel.self) var viewModel
    
    var body: some View {
        VStack {
            calendarHeaderView()
            .padding(.horizontal)

            WeeklyCalendarPageViewController()
                .frame(maxHeight: 80)
                        
            SelectedDateDetailPageViewController()
                .frame(maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private func calendarHeaderView() -> some View {
        HStack(alignment: .center){
            Text(viewModel.selectedDate.monthAndDay())
                .font(.headline)
        }
    }
}

#Preview {
    HomeView()
        .environment(HomeViewModel())
}
