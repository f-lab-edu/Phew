//
//  RoutineView.swift
//  Phew
//
//  Created by dong eun shin on 4/20/25.
//

import SwiftUI

struct RoutineView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        print("닫기 버튼 탭")
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding()
                    }
                }

                Spacer()

                VStack(spacing: 16) {
                    Text("첫 번째 라벨")
                        .font(.title)
                    Text("두 번째 라벨")
                        .font(.title2)
                    Text("세 번째 라벨")
                        .font(.body)
                }
                .multilineTextAlignment(.center)

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        print("다음 버튼 탭")
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
