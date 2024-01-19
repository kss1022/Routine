//
//  TimerMonthRecordDto.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation



struct TimerMonthRecordDto{
    let timerId: UUID    
    let month: String
    let done: Int
    let time: TimeInterval
}
