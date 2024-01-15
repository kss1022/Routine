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
    let emoji: String
    let tint: String
    let timerType: TimerTypeDto
    
    init(timerId: UUID, timerName: String, emoji: String, tint: String, timerType: TimerType) {
        self.timerId = timerId
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = TimerTypeDto(timerType)
    }
    
    init(timerId: UUID, timerName: String, emoji: String, tint: String, timerType: TimerTypeDto) {
        self.timerId = timerId
        self.timerName = timerName        
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
    }
}
