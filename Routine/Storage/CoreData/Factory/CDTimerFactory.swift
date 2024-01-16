//
//  CDTimerFactory.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



final class CDTimerFactory: TimerFactory{
    
    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, minutes: Minutes) -> FocusTimer {
        FocusTimer(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, minutes: minutes)
    }
    
    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, ready: Ready, exercise: Exercise, rest: Rest, round: Round, cycle: Cycle, cycleRest: CycleRest, cooldown: Cooldown) -> TabataTimer {
        TabataTimer(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, ready: ready, exercise: exercise, rest: rest, round: round, cycle: cycle, cycleRest: cycleRest, cooldown: cooldown)
    }
    
    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, ready: Ready, exercise: Exercise, rest: Rest, round: Round, cooldown: Cooldown) -> RoundTimer {
        RoundTimer(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, ready: ready, exercise: exercise, rest: rest, round: round, cooldown: cooldown)
    }
    
    func create(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint,  timerType: TimerType, timerSections: TimerSections) -> SectionTimer{
        SectionTimer(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, timerSections: timerSections)
    }
    
    
}
