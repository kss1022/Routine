//
//  TimerRecordCompleteSet.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



final class TimerRecordCompleteSet: DomainEvent{
    let recordId: RecordId
    let timeRecord: TimeRecord
    
    init(recordId: RecordId, timeRecord: TimeRecord){
        self.recordId = recordId
        self.timeRecord = timeRecord
        super.init()
    }
    
    override func encode(with coder: NSCoder) {
        recordId.encode(with: coder)
        timeRecord.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let recordId = RecordId(coder: coder),
              let timeRecord = TimeRecord(coder: coder)
               else { return nil }
                
        self.recordId = recordId
        self.timeRecord = timeRecord
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true

}
