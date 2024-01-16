//
//  RoundTimerUpdated.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation



final class RoundTimerUpdated : DomainEvent{
    let timerId: TimerId
    let timerName: TimerName
    let emoji: Emoji
    let tint: Tint
    let timerType: TimerType
    let ready: Ready
    let exercise: Exercise
    let rest: Rest
    let round: Round
    let cooldown: Cooldown

    
    init(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, ready: Ready, exercise: Exercise, rest: Rest, round: Round, cooldown: Cooldown) {
        self.timerId = timerId
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
        self.ready = ready
        self.exercise = exercise
        self.rest = rest
        self.round = round
        self.cooldown = cooldown
        super.init()
    }
   
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        timerName.encode(with: coder)
        emoji.encode(with: coder)
        tint.encode(with: coder)
        timerType.encode(with: coder)
        ready.encode(with: coder)
        exercise.encode(with: coder)
        rest.encode(with: coder)
        round.encode(with: coder)
        cooldown.encode(with: coder)
        super.encode(with: coder)
    }
    
    required override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder),
              let timerName = TimerName(coder: coder),
              let emoji = Emoji(coder: coder),
              let tint = Tint(coder: coder),
              let timerType = TimerType(coder: coder),
              let ready = Ready(coder: coder),
              let exercise = Exercise(coder: coder),
              let rest = Rest(coder: coder),
              let round = Round(coder: coder),
              let cooldown = Cooldown(coder: coder)
        else { return nil}
        
        self.timerId = timerId
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
        self.ready = ready
        self.exercise = exercise
        self.rest = rest
        self.round = round
        self.cooldown = cooldown
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
}

