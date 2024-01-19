//
//  RecordFactory.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation




protocol RecordFactory{
    func create(routineId: RoutineId, recordId: RecordId, recordDate: RecordDate, isComplete: Bool) -> RoutineRecord
    
    func create(timeId: TimerId, recordId: RecordId, recordDate: RecordDate, timeRecord: TimeRecord) -> TimerRecord
}
