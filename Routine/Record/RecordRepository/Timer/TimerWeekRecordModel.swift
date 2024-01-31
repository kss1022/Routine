//
//  TimerWeekRecordModel.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation



struct TimerWeekRecordModel{
    let timerId: UUID
    let startOfWeek: String
    let endOfWeek: String
    
    let sundayDone: Int
    let sundayTime: TimeInterval
    
    let mondayDone: Int
    let mondayTime: TimeInterval
    
    let tuesdayDone: Int
    let tuesdayTime: TimeInterval
    
    let wednesdayDone: Int
    let wednesdayTime: TimeInterval
    
    let thursdayDone: Int
    let thursdayTime: TimeInterval
    
    let fridayDone: Int
    let fridayTime: TimeInterval
    
    let saturdayDone: Int
    let saturdayTime: TimeInterval
    
    init(_ dto: TimerWeekRecordDto) {
        self.timerId = dto.timerId
        self.startOfWeek = dto.startOfWeek
        self.endOfWeek = dto.endOfWeek
        self.sundayDone = dto.sundayDone
        self.sundayTime = dto.sundayTime
        self.mondayDone = dto.mondayDone
        self.mondayTime = dto.mondayTime
        self.tuesdayDone = dto.tuesdayDone
        self.tuesdayTime = dto.tuesdayTime
        self.wednesdayDone = dto.wednesdayDone
        self.wednesdayTime = dto.wednesdayTime
        self.thursdayDone = dto.thursdayDone
        self.thursdayTime = dto.thursdayTime
        self.fridayDone = dto.fridayDone
        self.fridayTime = dto.fridayTime
        self.saturdayDone = dto.saturdayDone
        self.saturdayTime = dto.saturdayTime
    }
}
