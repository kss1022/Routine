//
//  RoutineWeeklyTrackerDto.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation



struct RoutineWeeklyTrackerDto{
    let routineId: UUID
    let routineName: String
    let emojiIcon: String
    let tint: String
    let year: Int
    let weekOfYear: Int
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
}
