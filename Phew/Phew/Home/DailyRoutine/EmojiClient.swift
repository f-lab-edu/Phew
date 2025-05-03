//
//  EmojiClient.swift
//  Phew
//
//  Created by dong eun shin on 5/2/25.
//

import Foundation
import Dependencies

struct EmojiClient {
    var loadEmojis: @Sendable () throws -> [Emoji]?
}

extension EmojiClient: DependencyKey {
    static let liveValue = Self(
        loadEmojis: {
            guard
                let url = Bundle.main.url(forResource: "emoji_unicodeScalars", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let emojis = try? JSONDecoder().decode([Emoji].self, from: data)
            else {
                    return nil
            }
            return emojis
        }
    )
}
