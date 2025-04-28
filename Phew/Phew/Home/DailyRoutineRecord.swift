//
//  DailyRoutineRecord.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import Foundation
import SwiftData

enum DailyRoutineType: String, Codable {
    case morning
    case night
}

@Model
class DailyRoutineRecord {
    @Attribute(.unique) var id: String
    var date: Date
    var dailyRoutineType: DailyRoutineType
    var responses: [DailyRoutineResponse]
    
    init(date: Date, dailyRoutineType: DailyRoutineType, responses: [DailyRoutineResponse]) {
        self.id = DailyRoutineRecord.makeID(date: date, dailyRoutineType: dailyRoutineType)
        self.date = date
        self.dailyRoutineType = dailyRoutineType
        self.responses = responses
    }
    
    static func makeID(date: Date, dailyRoutineType: DailyRoutineType) -> String {
        "\(date.monthAndDay())-\(dailyRoutineType.rawValue)"
    }
}

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

@Model
class DailyRoutineTask {
    @Attribute(.unique) var id: UUID
    var taskType: DailyRoutineTaskType
    var title: String
    var subTitle: String?
    var imageName: String?
    
    enum DailyRoutineTaskType: String, Codable {
        case question
        case slider
        case quote
    }
    
    init(id: UUID, taskType: DailyRoutineTaskType, title: String, subTitle: String? = nil, imageName: String? = nil) {
        self.id = id
        self.taskType = taskType
        self.title = title
        self.subTitle = subTitle
        self.imageName = imageName
    }
}
