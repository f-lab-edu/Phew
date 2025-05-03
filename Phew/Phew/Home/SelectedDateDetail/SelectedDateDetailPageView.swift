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
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>
    @Bindable var store: StoreOf<HomeFeature>
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
        .sheet(
            item: $store.scope(state: \.addRoutine, action: \.addRoutine)
        ) { routineStore in
            DailyRoutineView(store: routineStore)
        }
    }
    
    @ViewBuilder
    func dailyRoutineButtons() -> some View {
        HStack(spacing: 0) {
            Group {
                if let morningDailyRoutine = viewStore.state.morningDailyRoutineRecord {
                    Button {
                        // 저장한 루틴 디데일 화면
                    } label: {
                        VStack {
                            Text(morningDailyRoutine.responses.compactMap { $0.answerText?.toEmoji() }.reduce("", +))
                        }
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .background(.gray)
                        .foregroundColor(.white)
                    }
                    .padding()
                } else {
                    addRoutineButton(dailyRoutineType: .morning)
                }
            }
            
            Group {
                if let nightDailyRoutine = viewStore.state.nightDailyRoutineRecord {
                    Button {
                        // 저장한 루틴 디데일 화면
                    } label: {
                        VStack {
                            Text(nightDailyRoutine.responses.compactMap { $0.answerText?.toEmoji() }.reduce("", +))
                        }
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .background(.gray)
                        .foregroundColor(.white)
                    }
                    .padding()
                } else {
                    addRoutineButton(dailyRoutineType: .night)
                }
            }
        }
    }
    
    @ViewBuilder
    func addRoutineButton(dailyRoutineType: DailyRoutineType) -> some View {
        Button {
            if dailyRoutineType == .morning {
                store.send(.addMorningRoutineButtonTapped)
            } else {
                store.send(.addNightRoutineButtonTapped)
            }
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
    }
}
