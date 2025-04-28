//
//  SelectedDateDetailPageView.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import ComposableArchitecture
import SwiftData

struct SelectedDateDetailPageView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(HomeViewModel.self) var viewModel
    @State private var isPresenting = false
    
    let date: Date

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Group {
                    if let _ = viewModel.currentMorningRoutine {
                        Button {
                            isPresenting = true
                        } label: {
                            VStack {
                                Text("\(date.monthAndDay()) 데이터 있음")
                            }
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .background(.gray)
                            .foregroundColor(.white)
                        }
                        .padding()
                    } else {
                        routineView(dailyRoutineType: .morning, date: date)
                    }
                }
                .onAppear {
                    viewModel.fetchRecord(
                        date: date,
                        dailyRoutineType: .morning,
                        context: modelContext
                    )
                }
                
                routineView(dailyRoutineType: .night, date: date)
            }
            
            // 날짜 확인용
            Text(date.monthAndDay())
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func routineView(dailyRoutineType: DailyRoutineType, date: Date) -> some View {
        Button {
            isPresenting = true
        } label: {
            VStack {
                Image(systemName: "heart")
                
                Text("title")
                
                Text("subtitle")
            }
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(.gray)
            .foregroundColor(.white)
        }
        .padding()
        .sheet(isPresented: $isPresenting) {
            RoutineView(
                store: Store(initialState: RoutineFeature.State.init(mode: .morning)) { RoutineFeature() },
                date: date,
                dailyRoutineType: dailyRoutineType,
                dailyRoutineTasks: [
                    // 임시 데이터
                    DailyRoutineTask(id: UUID(), taskType: .slider, title: "1", subTitle: "1", imageName: "heart"),
                    DailyRoutineTask(id: UUID(), taskType: .question, title: "2", subTitle: "2", imageName: "heart"),
                    DailyRoutineTask(id: UUID(), taskType: .quote, title: "3", subTitle: "3", imageName: "heart")
                ]
            )
        }
    }
}
