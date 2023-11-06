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
    private(set) var timeRecord: TimeRecord!
    
    
    init(
        timerId: TimerId,
        recordId: RecordId,
        timeRecord: TimeRecord
    ) {
        self.timerId = timerId
        self.recordId = recordId
        self.timeRecord = timeRecord
        
        super.init()
        
        changes.append(
            TimerRecordCreated(timerId: timerId, recordId: recordId, timeRecord: timeRecord)
        )
    }
        
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? TimerRecordCreated{
            when(created)
        }else if let completeSet = event as? TimerRecordCompleteSet{
            when(completeSet)
        }else{
            Log.e("Event is not handling")
        }
    }
    
    private func when(_ event: TimerRecordCreated){
        self.timerId = event.timerId
        self.recordId = event.recordId
        self.timeRecord = event.timeRecord
    }
    
    
    func when(_ event: TimerRecordCompleteSet){
        self.timeRecord = event.timeRecord
    }
  
    
    func setComplete(endAt: Date, duration: Double) throws{
        self.timeRecord = try TimeRecord(startAt: self.timeRecord.startAt, endAt: endAt, duration: duration)
        changes.append(TimerRecordCompleteSet(recordId: recordId, timeRecord: timeRecord))
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
