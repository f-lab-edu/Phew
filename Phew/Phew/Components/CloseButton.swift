//
//  CloseButton.swift
//  Phew
//
//  Created by dong eun shin on 5/4/25.
//

import SwiftUI

struct CloseButton: View {
    var action: () -> Void
    var iconName: String = "xmark"
    var foregroundColor: Color = .black
    var backgroundColor: Color = Color.gray.opacity(0.2)
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .padding(12)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(Circle())
        }
    }
}
