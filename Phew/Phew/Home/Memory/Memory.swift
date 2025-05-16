//
//  Memory.swift
//  Phew
//
//  Created by dong eun shin on 5/4/25.
//

import Foundation
import SwiftData

@Model
class Memory {
    @Attribute(.unique) var id: String
    var date: Date
    var text: String
    var images: [Data]?
    var isGoodMemory: Bool

    init(date: Date, text: String, images: [Data]? = nil, isGoodMemory: Bool) {
        id = Memory.makeID(date: date)
        self.date = date
        self.text = text
        self.images = images
        self.isGoodMemory = isGoodMemory
    }

    static func makeID(date: Date) -> String {
        date.monthAndDay()
    }
}
