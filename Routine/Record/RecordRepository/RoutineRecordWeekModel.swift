//
//  RoutineRecordWeekModel.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation




struct RoutineRecordWeekModel{
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(_ dto: RoutineWeekRecordDto?) {
        guard let weekDto = dto else {
            self.sunday = false
            self.monday = false
            self.tuesday = false
            self.wednesday = false
            self.thursday = false
            self.friday = false
            self.saturday = false
            return 
        }
                
        self.sunday = weekDto.sunday
        self.monday = weekDto.monday
        self.tuesday = weekDto.tuesday
        self.wednesday = weekDto.wednesday
        self.thursday = weekDto.thursday
        self.friday = weekDto.friday
        self.saturday = weekDto.saturday
    }
}
