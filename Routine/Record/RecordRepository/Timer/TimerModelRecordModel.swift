//
//  TimerModelRecordModel.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation



struct TimerMonthRecordModel{
    let timerId: UUID
    let month: String
    let done: Int
    let time: TimeInterval
    
    init(_ dto: TimerMonthRecordDto) {
        self.timerId = dto.timerId
        self.month = dto.month
        self.done = dto.done
        self.time = dto.time
    }
}
