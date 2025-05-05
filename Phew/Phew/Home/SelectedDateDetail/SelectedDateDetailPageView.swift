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
            
            memoryButtons()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            store.send(.fetchSelectedDateDailyRoutineRecord)
            store.send(.fetchMemory)
        }
        .sheet(
            item: $store.scope(state: \.addRoutine, action: \.addRoutine)
        ) { routineStore in
            DailyRoutineView(store: routineStore)
        }
        .sheet(
            item: $store.scope(state: \.addMemory, action: \.addMemory)
        ) { routineStore in
            AddMemoryView(store: routineStore)
        }
    }
    
    @ViewBuilder
    func dailyRoutineButtons() -> some View {
        HStack(spacing: 0) {
            Group {
                if let morningDailyRoutine = viewStore.state.morningDailyRoutineRecord {
                    editRoutineButton(dailyRoutineRecord: morningDailyRoutine)
                } else {
                    addRoutineButton(dailyRoutineType: .morning)
                }
            }
            
            Group {
                if let nightDailyRoutine = viewStore.state.nightDailyRoutineRecord {
                    editRoutineButton(dailyRoutineRecord: nightDailyRoutine)
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
            .cornerRadius(10)
        }
        .padding()
    }
    
    @ViewBuilder
    func editRoutineButton(dailyRoutineRecord: DailyRoutineRecord) -> some View {
        Button {
            // TODO: - 저장한 루틴 디데일 화면으로 이동
        } label: {
            VStack {
                Text(dailyRoutineRecord.responses.compactMap { $0.answerText?.toEmoji() }.reduce("", +))
            }
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    @ViewBuilder
    func memoryButtons() -> some View {
        HStack(spacing: 0) {
            Group {
                if let selectedDateMemory = viewStore.state.selectedDateMemory {
                    editMemoryButton(memory: selectedDateMemory)
                } else {
                    addMemoryButton()
                }
            }
        }
    }
    
    @ViewBuilder
    func addMemoryButton() -> some View {
        Button {
            store.send(.addMemoryButtonTapped)
        } label: {
            Text("Add Memory")
                .font(.title)
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func editMemoryButton(memory: Memory) -> some View {
        Button {
            // TODO: - 일기 디테일 화면으로 이동
        } label: {
            Text("작성된 일기 있음")
                .font(.title)
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}

#Preview {
    SelectedDateDetailPageView(
        store: .init(
            initialState: HomeFeature.State.init(),
            reducer: {
                HomeFeature()
        }),
        date: .now
    )
}
