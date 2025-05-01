//
//  DailyRoutineTask.swift
//  Phew
//
//  Created by dong eun shin on 4/29/25.
//

import Foundation
import SwiftData

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
