//
//  CDRecordFactory.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation


final class CDRecordFactory: RecordFactory{

        
    func create(routineId: RoutineId, recordId: RecordId, recordDate: RecordDate, isComplete: Bool) -> RoutineRecord {
        RoutineRecord(routineId: routineId, recordId: recordId, recordDate: recordDate, isComplete: isComplete)
    }

    
    func create(timeId: TimerId, recordId: RecordId, recordDate: RecordDate, timeRecord: TimeRecord) -> TimerRecord {
        TimerRecord(timerId: timeId, recordId: recordId, recordDate: recordDate, timeRecord: timeRecord)
    }
    
    
}
