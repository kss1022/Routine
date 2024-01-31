//
//  TimerTotalRecordModel.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation



struct TimerTotalRecordModel{
    let timerId: UUID
    let done: Int
    let time: TimeInterval
    
    
    init(_ dto: TimerTotalRecordDto) {
        self.timerId = dto.timerId
        self.done = dto.done
        self.time = dto.time
    }
}
