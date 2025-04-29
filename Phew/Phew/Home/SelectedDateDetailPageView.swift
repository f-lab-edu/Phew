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
    @Bindable var store: StoreOf<HomeFeature>

    @State private var isPresenting = false
    
    let date: Date

    var body: some View {
        WithViewStore(store, observe: { $0 }) { store in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Group {
                        if store.state.morningDailyRoutineRecord != nil {
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
                            routineButton(dailyRoutineType: .morning, date: date)
                        }
                    }
                    
                    Group {
                        if store.state.nightDailyRoutineRecord != nil {
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
                            routineButton(dailyRoutineType: .night, date: date)
                        }
                    }
                }
                
                // 날짜 확인용
                Text(date.monthAndDay())
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .onAppear {
                store.send(.fetchSelectedDateDailyRoutineRecord)
            }
        }
    }
    
    @ViewBuilder
    func routineButton(dailyRoutineType: DailyRoutineType, date: Date) -> some View {
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
                store: Store(
                    initialState: RoutineFeature.State.init(dailyRoutineType: dailyRoutineType)
                ) {
                    RoutineFeature()
                },
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
