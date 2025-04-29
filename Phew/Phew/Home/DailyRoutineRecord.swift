//
//  DailyRoutineRecord.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import Foundation
import SwiftData

enum DailyRoutineType: String, Codable, Identifiable {
    case morning
    case night
    
    var id: String { self.rawValue }
}

@Model
class DailyRoutineRecord {
    @Attribute(.unique) var id: String
    var date: Date
    var dailyRoutineType: DailyRoutineType
//    var responses: [DailyRoutineResponse]
    
    init(date: Date, dailyRoutineType: DailyRoutineType) {
        self.id = DailyRoutineRecord.makeID(date: date, dailyRoutineType: dailyRoutineType)
        self.date = date
        self.dailyRoutineType = dailyRoutineType
    }
    
    static func makeID(date: Date, dailyRoutineType: DailyRoutineType) -> String {
        "\(date.monthAndDay())-\(dailyRoutineType.rawValue)"
    }
}
