//
//  RecordApplicationService.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



final class RecordApplicationService: ApplicationService{
    
    internal var eventStore: EventStore
    internal var snapshotRepository: SnapshotRepository
    
    private let recordFactory: RecordFactory
    
    init(
        eventStore: EventStore,
        snapshotRepository: SnapshotRepository,
        recordFactory: RecordFactory
    ) {
        self.eventStore = eventStore
        self.snapshotRepository = snapshotRepository
        self.recordFactory = recordFactory
    }
    
    
    func when(_ command: CreateRecord) async throws{
        do{
            Log.v("When (\(CreateRecord.self)):  \(command)")

            let routindId = RoutineId(command.routineId)
            let recordId = RecordId(UUID())
            let recordDate = RecordDate(date: command.date)
            let isComplete = command.isComplete
            
            let record = recordFactory.create(routineId: routindId, recordId: recordId, recordDate: recordDate, isComplete: isComplete)
            try eventStore.appendToStream(id: record.recordId.id, expectedVersion: -1, events: record.changes)

            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: SetCompleteRecord) async throws{
        do{
            Log.v("When (\(SetCompleteRecord.self)):  \(command)")

            
            let recordId = RecordId(UUID())
            let isComplete = command.isComplete
            
            
            try update(id: command.recordId) { (record: Record) in
                try record.setComplete(isComplete: isComplete)
                return ()
            }

            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
}
