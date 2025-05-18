//
//  AudioPlayer.swift
//  Phew
//
//  Created by dong eun shin on 5/18/25.
//

import AVFoundation
import OSLog

private let logger = Logger(subsystem: "Phew", category: "AudioPlayer")

protocol AudioPlayerProtocol {
    func play()
    func pause()
}

final class AudioPlayer: AudioPlayerProtocol {
    private var player: AVAudioPlayer?

    init(fileName: String, fileType: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            logger.error("Failed to initialize audio player: \(error.localizedDescription)")
        }
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }
}
