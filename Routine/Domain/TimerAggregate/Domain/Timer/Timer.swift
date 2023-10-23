//
//  Timer.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



final class Timer : DomainEntity{
    private(set) var timerId: TimerId!
    private(set) var timerName: TimerName!
    private(set) var timerType: TimerType!
    private(set) var timerSections: [TimerSection]!

    
    init(timerId: TimerId, timerName: TimerName, timerType: TimerType, timerSections: [TimerSection]) {
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        self.timerSections = timerSections
        super.init()
        
        changes.append(TimerCreated(timerId: timerId, timerName: timerName, timerType: timerType, timerSecions: timerSections))
    }
    
    public required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? TimerCreated{
            when(created)
        }else if let updated = event as? TimerUpdated{
            when(updated)
        }else{
            Log.e("Event is not handling")
        }
    }
    
    private func when(_ event: TimerCreated){
        self.timerId = event.timerId
        self.timerName = event.timerName
        self.timerType = event.timerType
        self.timerSections = event.timerSections
    }
    
    private func when(_ event: TimerUpdated){
        self.timerId = event.timerId
        self.timerName = event.timerName
        self.timerType = event.timerType
    }
    
    func updateTime(timerName: TimerName, timerType: TimerType){
        self.timerName = timerName
        self.timerType = timerType
        
        changes.append(TimerUpdated(timerId: self.timerId, timerName: timerName, timerType: timerType))
    }
    
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        timerName.encode(with: coder)
        timerType.encode(with: coder)
        timerSections.map(EncodableTimerSection.init).encode(with: coder)
        super.encode(with: coder)
    }
    
    required override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder),
              let timerName = TimerName(coder: coder),
              let timerType = TimerType(coder: coder),
              let sections = [EncodableTimerSection].decode(coder: coder)

        else { return nil}
        
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        self.timerSections = sections.compactMap{ $0.timerSection }
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
}
