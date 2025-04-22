//
//  RoutineLog.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI
import SwiftData

@Model
class RoutineLog {
    var id: UUID
    var date: Date
    var text: String

    init(date: Date, text: String) {
        self.id = UUID()
        self.date = date
        self.text = text
    }
}
