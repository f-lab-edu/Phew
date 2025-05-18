//
//  MeditationView.swift
//  Phew
//
//  Created by dong eun shin on 5/18/25.
//

import ComposableArchitecture
import PhewComponent
import SwiftUI

struct MeditationView: View {
    let store: StoreOf<MeditationFeature>
    @ObservedObject var viewStore: ViewStoreOf<MeditationFeature>

    @State private var rotationDegrees: Double = 0
    @State private var animationTimer: Timer?

    init(store: StoreOf<MeditationFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()

                    CloseButton {
                        viewStore.send(.closeButtonTapped)
                    }
                }
                .padding(.horizontal)

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 200, height: 200)

                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .offset(x: 100)
                        .rotationEffect(Angle(degrees: rotationDegrees))
                        .animation(.linear(duration: 0.02), value: rotationDegrees)
                }
                .padding()

                Text(elapsedTimeString(from: viewStore.elapsedTime))
                    .font(.headline)
                    .padding(.bottom, 20)
                    .contentTransition(.numericText())

                musicPlayer()

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: viewStore.isPlaying) { _, isPlaying in
                handleAnimation(isPlaying: isPlaying)
            }
        }
    }

    @ViewBuilder
    private func musicPlayer() -> some View {
        Button {
            viewStore.send(.playPauseTapped)
        } label: {
            Image(systemName: viewStore.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
        }
        .padding(.top, 20)
    }

    private func elapsedTimeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func handleAnimation(isPlaying: Bool) {
        if isPlaying {
            startAnimationTimer()
        } else {
            stopAnimationTimer()
        }
    }
    
    private func startAnimationTimer() {
        stopAnimationTimer()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            withAnimation(.linear(duration: 0.02)) {
                rotationDegrees = (rotationDegrees + 0.72).truncatingRemainder(dividingBy: 360)
                if viewStore.isPlaying {
                    viewStore.send(.timerTicked)
                }
            }
        }
    }

    private func stopAnimationTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}
