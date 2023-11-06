//
//  TimerRecordCreated.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



final class TimerRecordCreated: DomainEvent{
    let timerId: TimerId
    let recordId: RecordId
    let timeRecord: TimeRecord
    
    init(timerId: TimerId, recordId: RecordId, timeRecord: TimeRecord){
        self.timerId = timerId
        self.recordId = recordId
        self.timeRecord = timeRecord
        super.init()
    }
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        recordId.encode(with: coder)
        timeRecord.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder),
              let recordId = RecordId(coder: coder),
              let timeRecord = TimeRecord(coder: coder)
               else { return nil }
        
        self.timerId = timerId
        self.recordId = recordId
        self.timeRecord = timeRecord
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
    
}
