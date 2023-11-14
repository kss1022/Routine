//
//  RoutineWeekRecordDto.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation



struct RoutineWeekRecordDto{
    let routineId: UUID
    let year: Int
    let weekOfYear: Int
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(routineId: UUID, year: Int, weekOfYear: Int, sunday: Bool = false, monday: Bool = false, tuesday: Bool = false, wednesday: Bool = false, thursday: Bool = false, friday: Bool = false, saturday: Bool = false) {
        self.routineId = routineId
        self.year = year
        self.weekOfYear = weekOfYear
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
    }
}
