//
//  PhewApp.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import Dependencies
import SwiftData
import SwiftUI

@main
struct PhewApp: App {
	@Dependency(\.modelContextProvider) var modelContextProvider

	var modelContext: ModelContext {
		guard let modelContext = try? modelContextProvider.context() else {
			fatalError("Could not find modelcontext")
		}
		return modelContext
	}

	var body: some Scene {
		WindowGroup {
			ContentView(
				store: .init(initialState: AppFeature.State.init()) {
					AppFeature()
				})
		}
		.modelContext(modelContext)
	}
}
