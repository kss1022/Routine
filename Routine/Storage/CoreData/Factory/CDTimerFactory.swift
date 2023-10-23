//
//  CDTimerFactory.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



final class CDTimerFactory: TimerFactory{
    func create(timerId: TimerId, timerName: TimerName, timerType: TimerType, timerSections: [TimerSection]) -> Timer{
        Timer(timerId: timerId, timerName: timerName, timerType: timerType, timerSections: timerSections)
    }
}
