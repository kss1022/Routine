//
//  Record.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



final class Record: DomainEntity{
    
    private(set) var routineId: RoutineId!
    private(set) var recordId: RecordId!
    private(set) var recordDate: RecordDate!
    private(set) var isComplete: Bool!
    
    init(
        routineId: RoutineId,
        recordId: RecordId,
        recordDate: RecordDate,
        isComplete: Bool
    ) {
        self.routineId = routineId
        self.recordId = recordId
        self.recordDate = recordDate
        self.isComplete = isComplete
        super.init()
        
        changes.append(
            RecordCreated(routineId: routineId, recordId: recordId, recordDate: recordDate, isComplete: isComplete)
        )
    }
        
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? RecordCreated{
            when(created)
        }else if let completeSet = event as? RecordCompleteSet{
            when(completeSet)
        }else{
            Log.e("Event is not handling")
        }
    }
    
    private func when(_ event: RecordCreated){
        self.routineId = event.routineId
        self.recordId = event.recordId
        self.recordDate = event.recordDate
        self.isComplete = event.isComplete
    }
    
    private func when(_ event: RecordCompleteSet){
        self.isComplete = event.isComplete
    }
    
    
    func setComplete(isComplete: Bool) throws{
        if self.isComplete == isComplete{
            throw ArgumentException("Record is Already complete: %@", isComplete ? "TRUE" : "FALSE")
        }
        
        self.isComplete = isComplete
                
        changes.append(
            RecordCompleteSet(recordId: self.recordId, isComplete: isComplete)
        )
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
    
    static var supportsSecureCoding: Bool = true
    

    private enum CodingKeys: String{
        case isComplete
    }
    
}
