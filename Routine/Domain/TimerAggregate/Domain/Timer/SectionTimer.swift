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
    private(set) var timerType: TimerType!
    private(set) var timerSections: TimerSections!

    
    init(timerId: TimerId, timerName: TimerName, timerType: TimerType, timerSections: TimerSections) {
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        self.timerSections = timerSections
        super.init()
        
        changes.append(SectionTimerCreated(timerId: timerId, timerName: timerName, timerType: timerType, timerSecions: timerSections))
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
        self.timerType = event.timerType
        self.timerSections = event.timerSections
    }
    
    private func when(_ event: SectionTimerUpdated){        
        self.timerName = event.timerName
        self.timerType = event.timerType
        self.timerSections = event.timerSections
    }
    
    func updateTimer(timerName: TimerName, timerType: TimerType, timerSections: TimerSections){
        
        self.timerName = timerName
        self.timerType = timerType
        self.timerSections = timerSections
        
        changes.append(SectionTimerUpdated(timerId: self.timerId, timerName: timerName, timerType: timerType, timerSecions: timerSections))
    }
    
    func deleteTimer(){
        changes.append(SectionTimerDeleted(timerId: self.timerId))
    }
    
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        timerName.encode(with: coder)
        timerType.encode(with: coder)
        timerSections.encode(with: coder)
        //timerSections.map(EncodableTimerSection.init).encode(with: coder)
        super.encode(with: coder)
    }
    
    required override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder),
              let timerName = TimerName(coder: coder),
              let timerType = TimerType(coder: coder),
              let timerSections = TimerSections(coder: coder)
              //let sections = [EncodableTimerSection].decode(coder: coder)

        else { return nil}
        
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        self.timerSections = timerSections
        //self.timerSections = sections.compactMap{ $0.timerSection }
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
}
