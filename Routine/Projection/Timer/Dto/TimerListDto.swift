//
//  TimerListDto.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation


struct TimerListDto{
    let timerId: UUID
    let timerName: String
    let timerType: TimerTypeDto
    let timerCountdown: Int?
    
    init(timerId: UUID, timerName: String, timerType: TimerType, timerCountdown: Int? = nil) {
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = TimerTypeDto(timerType)
        self.timerCountdown = timerCountdown
    }
    
    init(timerId: UUID, timerName: String, timerType: TimerTypeDto, timerCountdown: Int? = nil) {
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        self.timerCountdown = timerCountdown
    }
}
