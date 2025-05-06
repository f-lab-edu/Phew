//
//  MemoryDetailView.swift
//  Phew
//
//  Created by dong eun shin on 5/6/25.
//

import SwiftUI
import ComposableArchitecture

struct MemoryDetailView: View {
    var store: StoreOf<EditMemoryFeature>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Spacer()
                    
                    CloseButton {
                        store.send(.closeButtonTapped)
                    }
                }
                
                if let data = store.state.memory.images?.first,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(12)
                }
                
                Text(store.state.memory.text)
            }
            .padding(.horizontal)
        }
    }
}
