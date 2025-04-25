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

    let context: ModelContext
    
    var body: some View {
        AppTabView(selection: $selection, context: context)
    }
}

#Preview {
    let container = try! ModelContainer(for: DailyRoutineLog.self)
    
    ContentView(context: container.mainContext)
}
