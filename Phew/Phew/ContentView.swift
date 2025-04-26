//
//  ContentView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selection: AppScreen? = .calendar
    @State var viewModel = HomeViewModel()
    
    var body: some View {
        AppTabView(selection: $selection)
            .environment(HomeViewModel())
    }
}

#Preview {
    ContentView()
        .environment(HomeViewModel())
}
