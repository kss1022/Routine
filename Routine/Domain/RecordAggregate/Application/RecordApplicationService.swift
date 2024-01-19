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
    
    //MARK: RoutineRecord
    func when(_ command: CreateRoutineRecord) async throws{
        do{
            Log.v("When (\(CreateRoutineRecord.self)):  \(command)")

            let routindId = RoutineId(command.routineId)
            let recordId = RecordId(UUID())
            let recordDate = try RecordDate(command.date)
            let isComplete = command.isComplete
            
            let record = recordFactory.create(routineId: routindId, recordId: recordId, recordDate: recordDate, isComplete: isComplete)
            try eventStore.appendToStream(id: record.recordId.id, expectedVersion: -1, events: record.changes)

            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: SetCompleteRoutineRecord) async throws{
        do{
            Log.v("When (\(SetCompleteRoutineRecord.self)):  \(command)")

            let isComplete = command.isComplete
            try update(id: command.recordId) { (record: RoutineRecord) in
                try record.setComplete(isComplete: isComplete)
                return ()
            }

            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    //MARK: TimerRecord
    func when(_ command: CreateTimerRecord) async throws{
        do{
            Log.v("When (\(CreateTimerRecord.self)): \(command)")
            
            let timerId = TimerId(command.timerId)
            let recordId = RecordId(UUID())
                                    
            let recordDate = try RecordDate(command.recordDate)
            let timeRecord = try TimeRecord(startAt: command.startAt, endAt: command.endAt, duration: command.duration)
            
            let record = recordFactory.create(timeId: timerId, recordId: recordId, recordDate:  recordDate, timeRecord: timeRecord)
            try eventStore.appendToStream(id: record.recordId.id, expectedVersion: -1, events: record.changes)

            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    

}
