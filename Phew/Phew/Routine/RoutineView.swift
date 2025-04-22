//
//  RoutineView.swift
//  Phew
//
//  Created by dong eun shin on 4/20/25.
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
    @State private var sliderIsActive = false

    let routineList: [Routine]

    var body: some View {
        VStack {
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
                TabView(selection: .constant(store.selectedIndex)) {
                    ForEach(Array(routineList.enumerated()), id: \.offset) { index, routine in
                        switch routine.responseType {
                        case .text:
                            VStack(alignment: .leading, spacing: 0) {
                                Text(routine.title)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)

                                TextEditor(text: $answerText)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(index)
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
                                
                                // 원하는 대로 작동안됨
                                Slider(value: $selectedScore, in:  0...5, step: 1)
                                    .padding(.horizontal)

                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(index)
                            
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
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(index)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
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
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    RoutineView(store: Store(initialState: RoutineFeature.State.init(mode: .morning)) {
        RoutineFeature()
    }, routineList: [
        Routine(title: "1", description: "1", imageName: "heart", responseType: .text),
        Routine(title: "2", description: "2", imageName: "heart", responseType: .score),
        Routine(title: "3", description: "3", imageName: "heart", responseType: .none)
    ])
}
