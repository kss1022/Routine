//
//  CDTimerFactory.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



final class CDTimerFactory: TimerFactory{

    func create(timerId: TimerId, timerName: TimerName, timerType: TimerType, timerSections: TimerSections) -> SectionTimer{
        SectionTimer(timerId: timerId, timerName: timerName, timerType: timerType, timerSections: timerSections)
    }
    
    func create(timerId: TimerId, timerName: TimerName, timerType: TimerType, timerCountdown: TimerFocusCountdown) -> FocusTimer {
        FocusTimer(timerId: timerId, timerName: timerName, timerType: timerType, timerCountdown: timerCountdown)
    }
    
}
