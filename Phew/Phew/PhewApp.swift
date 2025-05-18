//
//  PhewApp.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import AVFoundation
import Dependencies
import SwiftData
import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Phew", category: "PhewApp")

@main
struct PhewApp: App {
	@Dependency(\.modelContextProvider) var modelContextProvider

    init() {
        configureAudioSession()
    }

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

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(
                .playback,
                mode: .default,
                options: [.duckOthers]
            )
            try audioSession.setActive(true)
        } catch {
            logger.error("Error setting audio session: \(error.localizedDescription)")
        }
    }
}
