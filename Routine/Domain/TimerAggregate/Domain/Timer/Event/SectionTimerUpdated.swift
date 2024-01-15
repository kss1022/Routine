//
//  SectionTimerUpdated.swift
//  Routine
//
//  Created by 한현규 on 1/10/24.
//

import Foundation


final class SectionTimerUpdated: DomainEvent{
    let timerId: TimerId
    let timerName: TimerName
    let emoji: Emoji
    let tint: Tint
    let timerType: TimerType
    let timerSections: TimerSections
    
    init(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, timerSecions: TimerSections) {
        self.timerId = timerId
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
        self.timerSections = timerSecions
        super.init()
    }
    
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        timerName.encode(with: coder)
        emoji.encode(with: coder)
        tint.encode(with: coder)
        timerType.encode(with: coder)
        timerSections.encode(with: coder)
        super.encode(with: coder)
    }
    
    
    override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder),
              let timerName = TimerName(coder: coder),
              let emoji = Emoji(coder: coder),
              let tint = Tint(coder: coder),
              let timerType = TimerType(coder: coder),
              let timerSections = TimerSections(coder: coder)
        else { return nil}
        
        
        self.timerId = timerId
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
        self.timerSections = timerSections
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
    

}

