//
//  TimerUpdated.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



final class TimerUpdated: DomainEvent{
    let timerId: TimerId
    let timerName: TimerName
    let timerType: TimerType
    
    init(timerId: TimerId, timerName: TimerName, timerType: TimerType) {
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        super.init()
    }

    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        timerName.encode(with: coder)
        timerType.encode(with: coder)
        super.encode(with: coder)
    }
    

    override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder),
              let timerName = TimerName(coder: coder),
              let timerType = TimerType(coder: coder)
                
        else { return nil}
        
        self.timerId = timerId
        self.timerName = timerName
        self.timerType = timerType
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
    
    
}

