//
//  RoutineView.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import ComposableArchitecture

struct Routine: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String

    /// 사용자의 응답 타입
    let responseType: ResponseType

    enum ResponseType {
        case text
        case score
        case none
    }
}

struct RoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<RoutineFeature>
    @State private var answerText: String = ""
    @State private var selectedScore = 3.0
    @FocusState var focused: Bool
    
    let routineList: [Routine]
        
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            
            Spacer()
            
            ZStack(alignment: .bottomTrailing) {
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(Array(routineList.enumerated()), id: \.offset) { index, routine in
                                pageView(for: routine, answerText: $answerText, selectedScore: $selectedScore)
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if store.selectedIndex < routineList.count - 1 {
                            store.send(.nextButtonTapped)
                        } else {
                            store.send(.doneButtonTapped(answer: answerText))
                            
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
            .ignoresSafeArea(.keyboard)
        }
    }
    
    @ViewBuilder
    private func pageView(
        for routine: Routine,
        answerText: Binding<String>,
        selectedScore: Binding<Double>,
    ) -> some View {
        switch routine.responseType {
        case .text:
            VStack(alignment: .leading, spacing: 0) {
                Text(routine.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                
                TextEditor(text: answerText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .border(.gray.opacity(0.2), width: 2)
                    .padding(.horizontal)
//                    .focused($focused)
            }
        case .score:
            VStack(spacing: 20) {
                Image(systemName: routine.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding()
                
                Text(routine.title)
                    .font(.title)
                    .bold()
                
                Text(routine.description)
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
        case .none:
            VStack(spacing: 20) {
                Image(systemName: routine.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding()
                
                Text(routine.title)
                    .font(.title)
                    .bold()
                
                Text(routine.description)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
    
    private func updateFocus(for routine: Routine) {
        if routine.responseType == .text {

        } else {
            UIApplication.shared.hideKeyboard()
        }
    }
}
    
#Preview {
    RoutineView(store: Store(initialState: RoutineFeature.State.init(mode: .morning)) {
        RoutineFeature()
    },
        routineList:[
            Routine(
                title: "1",
                description: "1",
                imageName: "heart",
                responseType: .text
            ),
            Routine(
                title: "2",
                description: "2",
                imageName: "heart",
                responseType: .score
            ),
            Routine(
                title: "3",
                description: "3",
                imageName: "heart",
                responseType: .none
            )
        ]
    )
}
