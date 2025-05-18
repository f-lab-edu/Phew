//
//  MeditationEnvironment.swift
//  Phew
//
//  Created by dong eun shin on 5/18/25.
//


import ComposableArchitecture

struct MeditationEnvironment {
    var audioPlayer: AudioPlayerProtocol
}

extension DependencyValues {
    var meditationEnvironment: MeditationEnvironment {
        get { self[MeditationEnvironment.self] }
        set { self[MeditationEnvironment.self] = newValue }
    }
}

extension MeditationEnvironment: DependencyKey {
    static let liveValue = MeditationEnvironment(
        audioPlayer: AudioPlayer(fileName: "inner-peace", fileType: "mp3")
    )
}
