//
//  ReminderModel.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation



struct ReminderModel{
    let routineId: UUID
    let routineName: String
    let emoji: String
    let title: String
    let body: String
    let year: Int?
    let month: Int?
    let day: Int?
    let weekDays: Set<Int>?
    let monthDays: Set<Int>?
    let hour: Int
    let minute: Int
    let `repeat`: Bool
    
    init(_ dto: ReminderDto) {
        self.routineId = dto.routineId
        self.routineName = dto.routineName
        self.emoji = dto.emoji
        self.title = dto.title
        self.body = dto.body
        self.year = dto.year
        self.month = dto.month
        self.day = dto.day
        self.weekDays = dto.weekDays
        self.monthDays = dto.monthDays
        self.hour = dto.hour
        self.minute = dto.minute
        self.repeat = dto.repeat
    }
}
