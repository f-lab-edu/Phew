//
//  PhewApp.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI
import SwiftData
import Dependencies

@main
struct PhewApp: App {
    @Dependency(\.modelContextProvider) var modelContextProvider
    
    var modelContext: ModelContext {
        guard let modelContext = try? self.modelContextProvider.context() else {
            fatalError("Could not find modelcontext")
        }
        return modelContext
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContext(self.modelContext)
    }
}
