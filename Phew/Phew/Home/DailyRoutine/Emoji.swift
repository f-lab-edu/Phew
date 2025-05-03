//
//  Emoji.swift
//  Phew
//
//  Created by dong eun shin on 5/2/25.
//

import Foundation

struct Emoji: Codable, Equatable {
    let category: String
    let unicodeScalars: [String]
}
