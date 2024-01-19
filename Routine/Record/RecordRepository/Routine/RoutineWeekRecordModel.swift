//
//  RoutineWeekRecordModel.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation




struct RoutineWeekRecordModel{
    let routineId: UUID
    let startOfWeek: String
    let endOfWeek: String
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(_ dto: RoutineWeekRecordDto) {
        self.routineId = dto.routineId
        self.startOfWeek = dto.startOfWeek
        self.endOfWeek = dto.endOfWeek
        self.sunday = dto.sunday
        self.monday = dto.monday
        self.tuesday = dto.tuesday
        self.wednesday = dto.wednesday
        self.thursday = dto.thursday
        self.friday = dto.friday
        self.saturday = dto.saturday
    }
}
