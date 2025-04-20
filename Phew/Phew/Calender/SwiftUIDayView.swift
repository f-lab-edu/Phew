//
//  SwiftUIDayView.swift
//  Phew
//
//  Created by dong eun shin on 4/19/25.
//

import SwiftUI

struct SwiftUIDayView: View {

    let dayNumber: Int
    let isSelected: Bool

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
            .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
            .background {
              Circle()
                .foregroundColor(isSelected ? Color(UIColor.systemBackground) : .clear)
            }
            .aspectRatio(1, contentMode: .fill)
            
            Text("\(dayNumber)").foregroundColor(Color(UIColor.label))
        }
        .accessibilityAddTraits(.isButton)
    }
}
