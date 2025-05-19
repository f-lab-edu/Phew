//
//  MeditationSession.swift
//  Phew
//
//  Created by dong eun shin on 5/19/25.
//

import SwiftData
import Foundation

@Model
final class MeditationSession {
    @Attribute(.unique) var id: String

    var date: Date
    
    /// 총 명상 시간
    var duration: TimeInterval
    
    init(date: Date, duration: TimeInterval = 0) {
        self.id = MeditationSession.makeID(date: date)
        self.date = date.toUTC()
        self.duration = duration
    }

    static func makeID(date: Date) -> String {
        "\(date.monthAndDay())"
    }
}
