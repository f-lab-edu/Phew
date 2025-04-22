//
//  PhewApp.swift
//  Phew
//
//  Created by dong eun shin on 4/11/25.
//

import SwiftUI

@main
struct PhewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: RoutineLog.self)
    }
}
