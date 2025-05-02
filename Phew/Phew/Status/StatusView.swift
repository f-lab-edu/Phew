//
//  StatusView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI
import ComposableArchitecture

struct StatusView: View {
    @ObservedObject var viewStore: ViewStoreOf<StatusFeature>
    var store: StoreOf<StatusFeature>

    init(store: StoreOf<StatusFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
        
    var body: some View {
        VStack {
            Circle()
                .fill(color(for: viewStore.score))
                .frame(
                    width: 200 * viewStore.scale,
                    height: 200 * viewStore.scale
                )
                .shadow(
                    color: color(for: viewStore.score).opacity(1.0),
                    radius: 30 * viewStore.scale,
                    x: 0, y: 4 * viewStore.scale
                )
                .animation(.easeInOut(duration: 0.1), value: viewStore.scale)
            
            // 색상 확인용
            Text("Score: \(viewStore.score)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Slider(value: Binding(
                get: { Double(viewStore.score) },
                set: { viewStore.send(.scoreChanged(Int($0))) }
            ), in: 0...100)
                .padding()
            // end
        }
        .onAppear {
            viewStore.send(.startTimer)
        }
        .onDisappear {
            viewStore.send(.stopTimer)
        }
    }

    private func color(for score: Int) -> Color {
        let clamped = Double(max(0, min(score, 100)))
        let red = (100 - clamped) / 50.0
        let green = clamped / 50.0
        return Color(
            red: red.clamped(to: 0...1),
            green: green.clamped(to: 0...1),
            blue: 0
        )
    }
}
