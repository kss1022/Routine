//
//  SectionTimerDeleted.swift
//  Routine
//
//  Created by 한현규 on 1/10/24.
//

import Foundation



final class SectionTimerDeleted: DomainEvent{
    let timerId: TimerId
    
    init(timerId: TimerId) {
        self.timerId = timerId
        super.init()
    }
    
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder) else { return nil}
        
        self.timerId = timerId
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool  = true
    
}
