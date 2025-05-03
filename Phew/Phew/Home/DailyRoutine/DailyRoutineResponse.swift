//
//  DailyRoutineResponse.swift
//  Phew
//
//  Created by dong eun shin on 4/29/25.
//

import Foundation
import SwiftData

@Model
class DailyRoutineResponse {
    @Attribute(.unique) var id: UUID
    var dailyRoutineResponseType: DailyRoutineResponseType
    var answerText: String?
    var answerScore: Int?
    
    enum DailyRoutineResponseType: String, Codable  {
        case text
        case score
        case none
    }
    
    init(id: UUID, dailyRoutineResponseType: DailyRoutineResponseType, answerText: String? = nil, answerScore: Int? = nil) {
        self.id = id
        self.dailyRoutineResponseType = dailyRoutineResponseType
        self.answerText = answerText
        self.answerScore = answerScore
    }
}
