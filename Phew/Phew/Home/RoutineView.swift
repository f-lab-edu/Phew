//
//  RoutineView.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import ComposableArchitecture

struct RoutineView: View {
    enum Focused: Hashable {
        case answer
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var answerText: String = ""
    @State private var selectedScore = 3.0
    @Bindable var store: StoreOf<RoutineFeature>
    @FocusState var focused: Focused?
    
    let dailyRoutineTasks: [DailyRoutineTask]
        
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                
                closeButton()
            }
            
            Spacer()
            
            ZStack(alignment: .bottomTrailing) {
                GeometryReader { geometry in
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 0) {
                                ForEach(Array(dailyRoutineTasks.enumerated()), id: \.offset) { index, task in
                                    pageView(
                                        for: task,
                                        answerText: $answerText,
                                        selectedScore: $selectedScore,
                                        focued: $focused
                                    )
                                    .frame(width: geometry.size.width)
                                    .tag(index)
                                }
                            }
                        }
                        .scrollTargetBehavior(.paging)
                        .onChange(of: store.selectedIndex) { oldValue, newValue in
                            // 추후 다시 수정
//                            if dailyRoutineTasks[newValue].taskType == .question {
//                                focused = .answer
//                            }
                            
                            withAnimation {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    nextButton()
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    @ViewBuilder
    private func pageView(
        for task: DailyRoutineTask,
        answerText: Binding<String>,
        selectedScore: Binding<Double>,
        focued: FocusState<Focused?>.Binding
    ) -> some View {
        switch task.taskType {
        case .question:
            VStack(alignment: .leading, spacing: 0) {
                Text(task.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                
                TextEditor(text: answerText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .border(.gray.opacity(0.2), width: 2)
                    .padding(.horizontal)
//                    .focused(focued, equals: .answer) // 추후 수정
            }
        case .slider:
            VStack(spacing: 20) {
                Image(systemName: task.imageName ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding()
                
                Text(task.title)
                    .font(.title)
                    .bold()
                
                Text(task.subTitle ?? "")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Slider(
                    value: selectedScore,
                    in: 0...5,
                    step: 1
                )
                .tint(.green)
                .frame(width: 250)
            }
        case .quote:
            VStack(spacing: 20) {
                Image(systemName: task.imageName ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding()
                
                Text(task.title)
                    .font(.title)
                    .bold()
                
                Text(task.subTitle ?? "")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private func closeButton() -> some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark")
                .foregroundColor(.black)
                .padding()
        }
    }
    
    @ViewBuilder
    private func nextButton() -> some View {
        Button(action: {
            if store.selectedIndex < dailyRoutineTasks.count - 1 {
                store.send(.nextButtonTapped)
            } else {
                store.send(.doneButtonTapped)
                
                dismiss()
            }
        }) {
            Image(systemName: "chevron.right")
                .padding(16)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding()
        }
    }
}
