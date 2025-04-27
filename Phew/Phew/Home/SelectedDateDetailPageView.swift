//
//  SelectedDateDetailPageView.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI
import ComposableArchitecture

struct SelectedDateDetailPageView: View {
    @State private var isPresenting = false
    
    let date: Date

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                routineView()
                
                routineView()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func routineView() -> some View {
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
            RoutineView(store: Store(initialState: RoutineFeature.State.init(mode: .morning)) {
                RoutineFeature()
            },
               routineList: [
                Routine(title: "1", description: "1", imageName: "heart", responseType: .text),
                Routine(title: "2", description: "2", imageName: "heart", responseType: .score),
                Routine(title: "3", description: "3", imageName: "heart", responseType: .none)
               ]
            )
        }
    }
}
