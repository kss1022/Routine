//
//  TimerWeekRecordDto.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation



struct TimerWeekRecordDto{
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
}
