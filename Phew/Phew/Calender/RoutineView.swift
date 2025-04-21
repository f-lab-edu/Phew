//
//  RoutineView.swift
//  Phew
//
//  Created by dong eun shin on 4/20/25.
//

import SwiftUI

struct Routine: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct RoutineView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPage = 0
    
    let routineList: [Routine] = [
            Routine(title: "1", description: "설명1", imageName: "star"),
            Routine(title: "2", description: "설명2", imageName: "heart"),
            Routine(title: "3", description: "설명3", imageName: "checkmark")
        ]
    
    var body: some View {
        ZStack {
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
                
                TabView(selection: $currentPage) {
                    ForEach(Array(routineList.enumerated()), id: \.offset) { index, routine in
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
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(20)
                        .padding()
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        if currentPage < routineList.count - 1 {
                            currentPage += 1
                        } else {
                            
                        }
                    }) {
                        Text("다음")
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding()
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    RoutineView()
}
