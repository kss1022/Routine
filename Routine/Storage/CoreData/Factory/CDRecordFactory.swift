//
//  CDRecordFactory.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation


final class CDRecordFactory: RecordFactory{
    
    func create(routineId: RoutineId, recordId: RecordId, recordDate: RecordDate, isComplete: Bool) -> Record {
        Record(routineId: routineId, recordId: recordId, recordDate: recordDate, isComplete: isComplete)
    }
    
    
    
}
