//
//  TimerFocusModel.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation



struct TimerFocusModel{
    let timerId: UUID
    let timerName: String
    let timerCountdown : TimerCountdownModel
    
    
    init(timerDto: TimerListDto, countdownDto: TimerCountdownDto){
        self.timerId = timerDto.timerId
        self.timerName = timerDto.timerName
        self.timerCountdown = TimerCountdownModel(countdownDto)
    }
}



struct TimerCountdownModel{
    let minute: Int
    
    init(_ dto: TimerCountdownDto) {
        self.minute = dto.minute
    }
}
