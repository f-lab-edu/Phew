//
//  StatusView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import ComposableArchitecture
import SwiftUI

struct StatusView: View {
    @State private var scale: CGFloat = 1.0

    @ObservedObject var viewStore: ViewStoreOf<StatusFeature>
    var store: StoreOf<StatusFeature>

    init(store: StoreOf<StatusFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        VStack {
            Circle()
                .fill(color(for: viewStore.score))
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
                .shadow(
                    color: color(for: viewStore.score).opacity(1.0),
                    radius: 30,
                    x: 0, y: 4
                )
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        scale = 1.2
                    }
                }

            // 색상 확인용
            Text("Score: \(viewStore.score)")
                .font(.caption)
                .foregroundColor(.gray)

            Slider(value: Binding(
                get: { Double(viewStore.score) },
                set: { viewStore.send(.scoreChanged(Int($0))) }
            ), in: 0 ... 100)
                .padding()
            // end
        }
    }

    private func color(for score: Int) -> Color {
        let clamped = Double(max(0, min(score, 100)))
        let red = (100 - clamped) / 50.0
        let green = clamped / 50.0
        return Color(
            red: red.clamped(to: 0 ... 1),
            green: green.clamped(to: 0 ... 1),
            blue: 0
        )
    }
}
