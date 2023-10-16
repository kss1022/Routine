//
//  RoutineDetailModel.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation



struct RoutineDetailModel{
    public let routineId: UUID
    public let routineName: String
    public let routineDescription: String
    public let repeatType: RepeatTypeDto
    public let repeatValue: RepeatValueDto
    public let reminderIsON: Bool
    public let reminderHour: Int?
    public let reminderMinute: Int?
    public let emojiIcon: String
    public let tint: String
    
    
    init(_ detail: RoutineDetailDto) {
        self.routineId = detail.routineId
        self.routineName = detail.routineName
        self.routineDescription = detail.routineDescription
        self.repeatType = detail.repeatType
        self.repeatValue = detail.repeatValue
        self.reminderIsON = detail.reminderIsOn
        self.reminderHour = detail.reminderHour
        self.reminderMinute = detail.reminderMinute
        self.emojiIcon = detail.emojiIcon
        self.tint = detail.tint
    }
}
