//
//  ContentView.swift
//  Phew
//
//  Created by dong eun shin on 4/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: AppScreen? = .calender

    var body: some View {
        AppTabView(selection: $selection)
    }
}

#Preview {
    ContentView()
}
