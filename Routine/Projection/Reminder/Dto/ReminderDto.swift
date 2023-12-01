//
//  ReminderDto.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation



struct ReminderDto{
    let routineId: UUID
    let routineName: String
    let emoji: String
    let title: String
    let body: String
    let identifires: String
    let year: Int?
    let month: Int?
    let day: Int?
    let weekDays: Set<Int>?
    let monthDays: Set<Int>?
    let hour: Int
    let minute: Int
    let `repeat`: Bool
    
    init(routineId: UUID, routineName: String, emoji: String, title: String, body: String, identifiers: [String], year: Int? ,month: Int? ,day: Int? ,weekDays: Set<Int>?, monthDays: Set<Int>?, hour: Int, minute: Int, repeat: Bool) {
        self.routineId = routineId
        self.routineName = routineName
        self.emoji = emoji
        self.title = title
        self.body = body
        self.identifires = identifiers.joined(separator: ",")
        self.year = year
        self.month = month
        self.day = day
        self.weekDays = weekDays
        self.monthDays = monthDays
        self.hour = hour
        self.minute = minute
        self.repeat = `repeat`
    }
    
    init(routineId: UUID, routineName: String, emoji: String, title: String, body: String, identifiers: String,  year: Int? ,month: Int? ,day: Int? ,weekDays: Set<Int>?, monthDays: Set<Int>?, hour: Int, minute: Int, repeat: Bool) {
        self.routineId = routineId
        self.routineName = routineName
        self.emoji = emoji
        self.title = title
        self.body = body
        self.identifires = identifiers
        self.year = year
        self.month = month
        self.day = day
        self.weekDays = weekDays
        self.monthDays = monthDays
        self.hour = hour
        self.minute = minute
        self.repeat = `repeat`
    }
    
    func getIdentifires() -> [String]{
        self.identifires.components(separatedBy: ",")
    }
}
