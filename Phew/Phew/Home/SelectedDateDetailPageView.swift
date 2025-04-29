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
    @State private var isPresenting = false
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>
    let store: StoreOf<HomeFeature>
    let date: Date

    init(store: StoreOf<HomeFeature>, date: Date) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
        self.date = date
    }
    
    var body: some View {
        VStack(spacing: 0) {
            dailyRoutineButtons()
            
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
    
    @ViewBuilder
    func dailyRoutineButtons() -> some View {
        HStack(spacing: 0) {
            Group {
                if viewStore.state.morningDailyRoutineRecord != nil {
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
                    routineButton(dailyRoutineType: .morning)
                }
            }
            
            Group {
                if viewStore.state.nightDailyRoutineRecord != nil {
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
                    routineButton(dailyRoutineType: .night)
                }
            }
        }
    }
    
    @ViewBuilder
    func routineButton(dailyRoutineType: DailyRoutineType) -> some View {
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
