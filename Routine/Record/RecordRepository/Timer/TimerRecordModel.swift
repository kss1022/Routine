//
//  TimerRecordModel.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation



struct TimerRecordModel{
    let timerId: UUID
    let recordId: UUID
    let recordDate: String
    let startAt: Date
    let endAt: Date
    let duration: TimeInterval
    
    init(_ dto: TimerRecordDto) {
        self.timerId = dto.timerId
        self.recordId = dto.recordId
        self.recordDate = dto.recordDate
        self.startAt = dto.startAt
        self.endAt = dto.endAt
        self.duration = dto.duration
    }
}
