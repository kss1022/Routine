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
    
    init(timerId: UUID, timerName: String, timerType: TimerType) {
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = TimerTypeDto(timerType)
    }
    
    init(timerId: UUID, timerName: String, timerType: TimerTypeDto) {
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType        
    }
}
