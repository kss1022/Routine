//
//  TimerRecord.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



final class TimerRecord: DomainEntity{
    
    private(set) var timerId: TimerId!
    private(set) var recordId: RecordId!
    private(set) var recordDate: RecordDate!
    private(set) var timeRecord: TimeRecord!
    
    
    init(
        timerId: TimerId,
        recordId: RecordId,
        recordDate: RecordDate,
        timeRecord: TimeRecord
    ) {
        self.timerId = timerId
        self.recordId = recordId
        self.recordDate = recordDate
        self.timeRecord = timeRecord
        
        super.init()
        
        changes.append(
            TimerRecordCreated(timerId: timerId, recordId: recordId, recordDate: recordDate, timeRecord: timeRecord)
        )
    }
        
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? TimerRecordCreated{
            when(created)
        }else{
            Log.e("Event is not handling")
        }
    }
    
    private func when(_ event: TimerRecordCreated){
        self.timerId = event.timerId
        self.recordId = event.recordId
        self.recordDate = event.recordDate
        self.timeRecord = event.timeRecord
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
