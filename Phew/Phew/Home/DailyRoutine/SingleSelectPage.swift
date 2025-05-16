//
//  SingleSelectPage.swift
//  Phew
//
//  Created by dong eun shin on 5/2/25.
//

import SwiftUI

struct SingleSelectPage: View {
    let question: String
    let items: [String]
    @Binding var selectedItem: String?

    var body: some View {
        ScrollView {
            Text(question)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.largeTitle)
                        .frame(width: 60, height: 60)
                        .background(
                            selectedItem == item
                                ? Color.green.opacity(0.2)
                                : Color.gray.opacity(0.1)
                        )
                        .clipShape(Circle())
                        .overlay {
                            if selectedItem == item {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .offset(x: 20, y: -20)
                            }
                        }
                        .onTapGesture {
                            if selectedItem == item {
                                selectedItem = nil
                            } else {
                                selectedItem = item
                            }
                        }
                }
            }
            .padding()
        }
    }
}
