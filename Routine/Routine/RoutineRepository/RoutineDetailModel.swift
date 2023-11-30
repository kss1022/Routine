//
//  RoutineDetailModel.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation


//TODO: Repeat Dto -> Model

struct RoutineDetailModel{
    public let routineId: UUID
    public let routineName: String
    public let routineDescription: String
//    public let repeatType: RepeatTypeDto
//    public let repeatValue: RepeatValueDto
    public let repeatModel: RepeatModel
    public let reminderIsON: Bool
    public let reminderHour: Int?
    public let reminderMinute: Int?
    public let emojiIcon: String
    public let tint: String
    
    
    init(_ dto: RoutineDetailDto) {
        self.routineId = dto.routineId
        self.routineName = dto.routineName
        self.routineDescription = dto.routineDescription
//        self.repeatType = detail.repeatType
//        self.repeatValue = detail.repeatValue
        self.repeatModel = RepeatModel(dto)
        self.reminderIsON = dto.reminderIsOn
        self.reminderHour = dto.reminderHour
        self.reminderMinute = dto.reminderMinute
        self.emojiIcon = dto.emojiIcon
        self.tint = dto.tint
    }
}
