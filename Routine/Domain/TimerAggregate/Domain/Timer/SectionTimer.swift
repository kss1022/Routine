//
//  SectionTimer.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



final class SectionTimer : DomainEntity{
    private(set) var timerId: TimerId!
    private(set) var timerName: TimerName!
    private(set) var emoji: Emoji!
    private(set) var tint: Tint!
    private(set) var timerType: TimerType!
    private(set) var timerSections: TimerSections!

    
    init(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint,timerType: TimerType, timerSections: TimerSections) {
        self.timerId = timerId
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
        self.timerSections = timerSections
        super.init()
        
        changes.append(SectionTimerCreated(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, timerSecions: timerSections))
    }
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? SectionTimerCreated{
            when(created)
        }else if let updated = event as? SectionTimerUpdated{
            when(updated)
        }else{
            Log.e("Event is not handling")
        }
    }
    
    private func when(_ event: SectionTimerCreated){
        self.timerId = event.timerId
        self.timerName = event.timerName
        self.emoji = event.emoji
        self.tint = event.tint
        self.timerType = event.timerType
        self.timerSections = event.timerSections
    }
    
    private func when(_ event: SectionTimerUpdated){        
        self.timerName = event.timerName
        self.emoji = event.emoji
        self.tint = event.tint
        self.timerType = event.timerType
        self.timerSections = event.timerSections
    }
    
    func updateTimer(timerName: TimerName, emoji: Emoji, tint: Tint, timerSections: TimerSections){
        
        self.timerName = timerName        
        self.emoji = emoji
        self.tint = tint
        self.timerSections = timerSections
        
        changes.append(SectionTimerUpdated(timerId: self.timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: self.timerType, timerSecions: timerSections))
    }
    
    func deleteTimer(){
        changes.append(SectionTimerDeleted(timerId: self.timerId))
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
    
    required override init?(coder: NSCoder) {
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
