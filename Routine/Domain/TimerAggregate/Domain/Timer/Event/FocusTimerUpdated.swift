//
//  FocusTimerUpdated.swift
//  Routine
//
//  Created by 한현규 on 1/10/24.
//

import Foundation


final class FocusTimerUpdated: DomainEvent{
    let timerId: TimerId
    let timerName: TimerName
    let timerCountdown: TimerFocusCountdown!
    let timerType: TimerType


    init(timerId: TimerId, timerName: TimerName, timerType: TimerType,timerCountdown: TimerFocusCountdown) {
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        self.timerCountdown = timerCountdown
        super.init()
    }
    
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        timerName.encode(with: coder)
        timerType.encode(with: coder)
        timerCountdown.encode(with: coder)
        super.encode(with: coder)
    }
    
    
    override init?(coder: NSCoder) {
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
