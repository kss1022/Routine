//
//  FocusTimer.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation



final class FocusTimer : DomainEntity{
    private(set) var timerId: TimerId!
    private(set) var timerName: TimerName!
    private(set) var emoji: Emoji!
    private(set) var tint: Tint!
    private(set) var timerType: TimerType!
    private(set) var minutes: Minutes!

    
    init(timerId: TimerId, timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, minutes: Minutes) {
        self.timerId = timerId
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
        self.minutes = minutes
        super.init()
        
        changes.append(FocusTimerCreated(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, minutes: minutes))
    }
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? FocusTimerCreated{
            when(created)
        }else if let updated = event as? FocusTimerUpdated{
            when(updated)            
        }else{
            Log.e("Event is not handling")
        }
    }
    
    private func when(_ event: FocusTimerCreated){
        self.timerId = event.timerId
        self.timerName = event.timerName
        self.emoji = event.emoji
        self.tint = event.tint
        self.minutes = event.minutes
    }
    
    private func when(_ event: FocusTimerUpdated){
        self.timerId = event.timerId
        self.timerName = event.timerName
        self.emoji = event.emoji
        self.tint = event.tint
        self.minutes = event.minutes
    }
    
    func updateTimer(timerName: TimerName, emoji: Emoji, tint: Tint, timerType: TimerType, minutes: Minutes){
        
        self.timerName = timerName
        self.emoji = emoji
        self.tint = tint
        self.timerType = timerType
        self.minutes = minutes
        
        changes.append(FocusTimerUpdated(timerId: self.timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, minutes: minutes))
    }
    
    func deleteTimer(){
        changes.append(FocusTimerDeleted(timerId: self.timerId))
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
    
    required override init?(coder: NSCoder) {
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
