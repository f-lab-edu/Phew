//
//  RoutineButton.swift
//  Phew
//
//  Created by dong eun shin on 4/21/25.
//

import SwiftUI

struct RoutineButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                
                Text(title)
                
                Text(subtitle)
            }
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(color)
            .foregroundColor(.white)
        }
    }
}
