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
    var images: [String]?
    
    init(id: String, date: Date, text: String, images: [String]? = nil) {
        self.id = id
        self.date = date
        self.text = text
        self.images = images
    }
}
