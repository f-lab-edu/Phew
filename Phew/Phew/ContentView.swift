//
//  ContentView.swift
//  Phew
//
//  Created by dong eun shin on 4/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RageButtonView()
            .modelContainer(for: RageButtonClickTime.self, inMemory: true)
    }
}

#Preview {
    ContentView()
}
