//
//  KeyboardAvoidingScrollView.swift
//  Phew
//
//  Created by dong eun shin on 5/4/25.
//

import SwiftUI

struct KeyboardAvoidingScrollView<Content: View>: View {
    @State private var keyboardHeight: CGFloat = 0
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            content
                .padding(.bottom, keyboardHeight)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
            if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    keyboardHeight = frame.height
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation {
                keyboardHeight = 0
            }
        }
    }
}
