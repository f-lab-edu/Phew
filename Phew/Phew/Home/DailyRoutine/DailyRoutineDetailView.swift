//
//  DailyRoutineDetailView.swift
//  Phew
//
//  Created by dong eun shin on 5/6/25.
//

import SwiftUI
import ComposableArchitecture

struct DailyRoutineDetailView: View {
    var store: StoreOf<EditDailyRoutineFeature>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Spacer()
                    
                    CloseButton {
                        store.send(.closeButtonTapped)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(store.state.record.responses, id: \.id) { response in
                        Text(response.question)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                        
                        if let answer = response.answerText?.toEmoji() {
                            Text(answer)
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .padding(.horizontal)
        }
    }
}
