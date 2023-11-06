//
//  RoutineRecordCreated.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



final class RoutineRecordCreated: DomainEvent{
    
    let routineId: RoutineId
    let recordId: RecordId
    let recordDate: RecordDate
    let isComplete: Bool
     
    
    init( routineId: RoutineId, recordId: RecordId, recordDate: RecordDate,isComplete: Bool) {
        self.routineId = routineId
        self.recordId = recordId
        self.recordDate = recordDate
        self.isComplete = isComplete
        super.init()
    }
    
    
    override func encode(with coder: NSCoder) {
        routineId.encode(with: coder)
        recordId.encode(with: coder)
        recordDate.encode(with: coder)
        coder.encodeBool(isComplete, forKey: CodingKeys.isComplete.rawValue)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let routineId = RoutineId(coder: coder),
              let recordId = RecordId(coder: coder),
              let recordDate = RecordDate(coder: coder)
               else { return nil }
        
        self.routineId = routineId
        self.recordId = recordId
        self.recordDate = recordDate
        self.isComplete = coder.decodeBool(forKey: CodingKeys.isComplete.rawValue)
        super.init(coder: coder)
    }
    
    private enum CodingKeys: String{
        case isComplete
    }
    
    static var supportsSecureCoding: Bool = true
}
