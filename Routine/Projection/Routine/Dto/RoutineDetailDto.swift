//
//  RoutineDetailDto.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



public struct RoutineDetailDto{
    public let routineId: UUID
    public let routineName: String
    public let routineDescription: String
    public let repeatType: RepeatTypeDto
    public let repeatValue: RepeatValueDto
    public let reminderIsOn: Bool
    public let reminderHour: Int?
    public let reminderMinute: Int?
    public let emojiIcon: String
    public let tint: String
    public let updatedAt: Date
}
