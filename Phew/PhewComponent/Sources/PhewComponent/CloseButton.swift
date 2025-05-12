//
//  CloseButton.swift
//  PhewComponent
//
//  Created by dong eun shin on 5/12/25.
//

import SwiftUI

@available(iOS 17.0, *)
public struct CloseButton: View {
    public var action: () -> Void
    public var iconName: String
    public var foregroundColor: Color
    public var backgroundColor: Color

    public init(
        iconName: String = "xmark",
        foregroundColor: Color = .black,
        backgroundColor: Color = .white,
        action: @escaping () -> Void,
    ) {
        self.action = action
        self.iconName = iconName
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .padding(12)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(Circle())
        }
    }
}
