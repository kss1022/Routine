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
    let recordDate: RecordDate
    let timeRecord: TimeRecord
    
    init(timerId: TimerId, recordId: RecordId, recordDate: RecordDate, timeRecord: TimeRecord){
        self.timerId = timerId
        self.recordId = recordId
        self.recordDate = recordDate
        self.timeRecord = timeRecord
        super.init()
    }
    
    override func encode(with coder: NSCoder) {
        timerId.encode(with: coder)
        recordId.encode(with: coder)
        recordDate.encode(with: coder)
        timeRecord.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let timerId = TimerId(coder: coder),
              let recordId = RecordId(coder: coder),
              let recordDate = RecordDate(coder: coder),
              let timeRecord = TimeRecord(coder: coder)
               else { return nil }
        
        self.timerId = timerId
        self.recordId = recordId
        self.recordDate = recordDate
        self.timeRecord = timeRecord
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
    
}
