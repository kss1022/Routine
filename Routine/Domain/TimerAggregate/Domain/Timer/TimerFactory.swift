//
//  TimerFactory.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



protocol TimerFactory{
    func create(timerId: TimerId, timerName: TimerName, timerType: TimerType, timerSections: TimerSections) -> SectionTimer
    func create(timerId: TimerId, timerName: TimerName, timerType: TimerType, timerCountdown: TimerFocusCountdown) -> FocusTimer
}
