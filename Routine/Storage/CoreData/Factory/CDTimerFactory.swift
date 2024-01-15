//
//  CDTimerFactory.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



final class CDTimerFactory: TimerFactory{

    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint,  timerType: TimerType, timerSections: TimerSections) -> SectionTimer{
        SectionTimer(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, timerSections: timerSections)
    }
    
    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, timerCountdown: TimerFocusCountdown) -> FocusTimer {
        FocusTimer(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, timerCountdown: timerCountdown)
    }
    
}
