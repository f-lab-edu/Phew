//
//  DailyRoutine.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import Foundation
import SwiftData

enum RoutineType: String, Codable {
    case morning
    case night
}

@Model
class DailyRoutineLog {
    /// 루틴 유형
    var routineType: RoutineType
    
    /// 등록 날짜
    var date: Date
    
    init(routineType: RoutineType, date: Date) {
        self.routineType = routineType
        self.date = date
    }
}
