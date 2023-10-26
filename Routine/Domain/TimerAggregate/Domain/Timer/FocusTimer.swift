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
    private(set) var timerType: TimerType!
    private(set) var timerCountdown: TimerFocusCountdown!

    
    init(timerId: TimerId, timerName: TimerName, timerType: TimerType, timerCountdown: TimerFocusCountdown) {
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        self.timerCountdown = timerCountdown
        super.init()
        
        changes.append(FocusTimerCreated(timerId: timerId, timerName: timerName, timerType: timerType, timerCountdown: timerCountdown))
    }
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? FocusTimerCreated{
            when(created)
        }else{
            Log.e("Event is not handling")
        }
    }
    
    private func when(_ event: FocusTimerCreated){
        self.timerId = event.timerId
        self.timerName = event.timerName
        self.timerCountdown = event.timerCountdown
    }
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        timerName.encode(with: coder)
        timerType.encode(with: coder)
        timerCountdown.encode(with: coder)
        super.encode(with: coder)
    }
    
    required override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder),
              let timerName = TimerName(coder: coder),
              let timerType = TimerType(coder: coder),
              let timerCountdown = TimerFocusCountdown(coder: coder)
        else { return nil}
        
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        self.timerCountdown = timerCountdown
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
}
