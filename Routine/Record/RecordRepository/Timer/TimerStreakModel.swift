//
//  TimerStreakModel.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation



struct TimerStreakModel{
    let timerId: UUID
    let startDate: String
    let endDate: String
    let streakCount: Int
    
    init(_ dto: TimerStreakDto) {
        self.timerId = dto.timerId
        self.startDate = dto.startDate
        self.endDate = dto.endDate
        self.streakCount = dto.streakCount
    }
}
