//
//  TimerFactory.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



protocol TimerFactory{
    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, minutes: Minutes) -> FocusTimer
    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, ready: Ready, exercise: Exercise, rest: Rest, round: Round, cycle: Cycle, cycleRest: CycleRest, cooldown: Cooldown) -> TabataTimer
    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, ready: Ready, exercise: Exercise, rest: Rest, round: Round, cooldown: Cooldown) -> RoundTimer
    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, timerSections: TimerSections) -> SectionTimer
    
    
    
}
