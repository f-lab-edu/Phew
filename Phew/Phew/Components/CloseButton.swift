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
    var backgroundColor: Color = .white
    
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
