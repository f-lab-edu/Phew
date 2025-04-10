//
//  RageButtonClickTime.swift
//  Phew
//
//  Created by dong eun shin on 4/11/25.
//

import Foundation
import SwiftData

@Model
class RageButtonClickTime {
    var startedAt: Date
    var endedAt: Date
    
    init(startedAt: Date, endedAt: Date) {
        self.startedAt = startedAt
        self.endedAt = endedAt
    }
}
