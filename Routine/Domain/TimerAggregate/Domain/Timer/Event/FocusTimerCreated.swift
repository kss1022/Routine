//
//  FocusTimerCreated.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation



final class FocusTimerCreated: DomainEvent{
    let timerId: TimerId
    let timerName: TimerName
    let emoji: Emoji
    let tint: Tint
    let minutes: Minutes!
    let timerType: TimerType


    init(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, minutes: Minutes) {
        self.timerId = timerId
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
        self.minutes = minutes
        super.init()
    }
    
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        timerName.encode(with: coder)
        emoji.encode(with: coder)
        tint.encode(with: coder)
        timerType.encode(with: coder)
        minutes.encode(with: coder)
        super.encode(with: coder)
    }
    
    
    override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder),
              let timerName = TimerName(coder: coder),
              let emoji = Emoji(coder: coder),
              let tint = Tint(coder: coder),
              let timerType = TimerType(coder: coder),
              let minutes = Minutes(coder: coder)
        else { return nil}
        
        self.timerId = timerId
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
        self.minutes = minutes
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
    
    
}



