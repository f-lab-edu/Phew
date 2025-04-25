//
//  PhewApp.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI
import SwiftData

@main
struct PhewApp: App {
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView(context: container.mainContext)
                .modelContainer(container)
        }
    }
    
    init() {
        do {
            container = try ModelContainer(for: DailyRoutineLog.self)
        } catch {
            fatalError("Failed to create container")
        }
    }
}
