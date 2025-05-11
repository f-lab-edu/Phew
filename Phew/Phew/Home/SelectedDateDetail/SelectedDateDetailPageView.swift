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
        NavigationStack {
            VStack(spacing: 0) {
                dailyRoutineButtons()
                
                memoryButtons()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            store.send(.fetchSelectedDateDailyRoutineRecord)
            store.send(.fetchMemory)
        }
        .fullScreenCover(
            item: $store.scope(state: \.addRoutine, action: \.addRoutine)
        ) { store in
            DailyRoutineView(store: store)
        }
        .fullScreenCover(
            item: $store.scope(state: \.addMemory, action: \.addMemory)
        ) { store in
            MemoryEditorView(store: store)
        }
        .fullScreenCover(
            item: $store.scope(state: \.routineDetail, action: \.showRoutineDetail)
        ) { store in
            DailyRoutineDetailView(store: store)
        }
        .navigationDestination(
            item: $store.scope(state: \.memoryDetail, action: \.showMemoryDetail))
        { store in
            MemoryDetailView(store: store)
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
                Image(systemName: dailyRoutineType == .morning ? "sun.max" : "moon")
                    .font(.system(size: 26, weight: .semibold))
                    .padding(2)
                
                Text(dailyRoutineType == .morning ? "Morning Magic" : "End Well")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(dailyRoutineType == .morning ? "Start the day" : "Ready for tomorrow")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(.green)
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
        }
        .padding(.leading, dailyRoutineType == .morning ? 16 : 8)
        .padding(.trailing, dailyRoutineType == .morning ? 8 : 16)
        .padding(.bottom)
    }
    
    @ViewBuilder
    func editRoutineButton(dailyRoutineRecord: DailyRoutineRecord) -> some View {
        Button {
            store.send(.routineDetailButtonTapped(dailyRoutineType: dailyRoutineRecord.dailyRoutineType))
        } label: {
            VStack {
                Text(dailyRoutineRecord.responses.compactMap { $0.answerText?.toEmoji() }.reduce("", +))
            }
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(.green.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
        }
        .padding(.leading, dailyRoutineRecord.dailyRoutineType == .morning ? 16 : 8)
        .padding(.trailing, dailyRoutineRecord.dailyRoutineType == .morning ? 8 : 16)
        .padding(.bottom)
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
        Button(action: {
            store.send(.addMemoryButtonTapped)
        }) {
            ZStack {
                VStack {
                    Text("Today, As It Was")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.top)
                    
                    Spacer()
                }
                
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.green))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green, lineWidth: 2)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
        )
        .padding([.bottom, .horizontal])
    }
    
    @ViewBuilder
    func editMemoryButton(memory: Memory) -> some View {
        Button(action: {
            store.send(.savedMemoryButtonTapped)
        }) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Today, As It Was")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                if let data = memory.images?.first,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                }
                
                Text(memory.text)
                    .font(.body)
                    .foregroundColor(.black.opacity(0.7))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green, lineWidth: 2)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
        )
        .padding([.bottom, .horizontal])
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
