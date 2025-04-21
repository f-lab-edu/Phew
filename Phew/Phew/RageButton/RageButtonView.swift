//
//  RageButtonView.swift
//  Phew
//
//  Created by dong eun shin on 4/11/25.
//

import SwiftUI
import SwiftData

struct RageButtonView: View {
    @Environment(\.modelContext) private var context

    @State private var isPresentingModal = false
    @State private var isPressing = false
    @State private var startAt: Date?
    @State private var endAt: Date?

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundStyle(.blue)
                    .frame(width: 300, height: 300)
                
                Text("Press Me")
                    .font(.largeTitle)
                    .frame(width: 250, height: 250)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .scaleEffect(isPressing ? 0.9 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressing)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if !isPressing {
                                    isPressing = true
                                    startAt = Date()
                                }
                            }
                            .onEnded { _ in
                                isPressing = false
                                endAt = Date()
                                if let start = startAt, let end = endAt {
                                    let newContext = RageButtonClickTime(startedAt: start, endedAt: end)
                                    
                                    context.insert(newContext)
                                }
                            }
                    )
            }
            .padding()
                        
            Button("History") {
                isPresentingModal = true
            }
        }
        .sheet(isPresented: $isPresentingModal) {
            RageButtonClickTimeHistoryView()
        }
    }
}

#Preview {
    RageButtonView()
        .modelContainer(for: RageButtonClickTime.self, inMemory: true)
}
