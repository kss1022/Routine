//
//  RecordProjection.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation
import Combine


final class RecordProjection{
    
    private let routineTotalRecordDao: RoutineTotalRecordDao
    private let routineMonthRecordDao: RoutineMonthRecordDao
    private let routineWeekRecordDao: RoutineWeekRecordDao
    private let routineRecordDao: RoutineRecordDao
    
    
    private let timerRecordDao: TimerRecordDao
    
    private var cancellables: Set<AnyCancellable>

    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
                
        self.routineRecordDao = dbManager.routineRecordDao
        self.routineTotalRecordDao = dbManager.routineTotalRecordDao
        self.routineMonthRecordDao = dbManager.routineMonthRecordDao
        self.routineWeekRecordDao = dbManager.routineWeekRecordDao
        
        self.timerRecordDao = dbManager.timerRecordDao
        cancellables = .init()
        
        registerReceiver()
    }
    
    
    private func registerReceiver(){
        DomainEventPublihser.share
            .onReceive(RoutineRecordCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(RoutineRecordCompleteSet.self, action: when)
            .store(in: &cancellables)
        
        
        DomainEventPublihser.share
            .onReceive(TimerRecordCreated.self, action: when)
            .store(in: &cancellables)
    }
    
    
    //MARK: Routine

    
    private func when(event: RoutineRecordCreated){
        do{
            let record = RoutineRecordDto(
                routineId: event.routineId.id,
                recordId: event.recordId.id,
                recordDate: Formatter.recordDate(event.recordDate),
                isComplete: event.isComplete,
                completedAt: event.occurredOn
            )
                        
            try routineRecordDao.save(record)
            try routineTotalRecordDao.updateTotalDone(routineId: event.routineId.id, increment: 1)
            try routineMonthRecordDao.updateDone(routineId: event.routineId.id, recordMonth: Formatter.recordMonth(event.recordDate), increment: 1)
            try routineWeekRecordDao.updateDone(routineId: event.routineId.id, year: event.recordDate.year, weekOfYear: event.recordDate.weekOfYear, dayOfWeek:event.recordDate.dayOfWeek, done: event.isComplete)

        }catch{
            Log.e("EventHandler Error: RecordCreated \(error)")
        }
    }
    
    private func when(event: RoutineRecordCompleteSet){
        do{
            try routineRecordDao.updateComplete(recordId: event.recordId.id, isComplete: event.isComplete, completeAt: event.occurredOn)
            try routineTotalRecordDao.updateTotalDone(routineId: event.routineId.id, increment: event.isComplete ? 1 : -1)
            try routineMonthRecordDao.updateDone(routineId: event.routineId.id, recordMonth: Formatter.recordMonth(event.recordDate),increment: event.isComplete ? 1 : -1)
            try routineWeekRecordDao.updateDone(routineId: event.routineId.id, year: event.recordDate.year, weekOfYear: event.recordDate.weekOfYear, dayOfWeek:event.recordDate.dayOfWeek, done: event.isComplete)
        }catch{
            Log.e("EventHandler Error: RecordCreated \(error)")
        }
    }


    //MARK: TimerRecord
    private func when(event: TimerRecordCreated){
        do{
            let record = TimerRecordDto(
                timerId: event.timerId.id,
                recordId: event.recordId.id,
                recordDate: Formatter.recordDateFormatter().string(from: event.timeRecord.startAt),
                startAt: event.timeRecord.startAt,
                endAt: event.timeRecord.endAt,
                duration: event.timeRecord.duration
            )
                        
            try timerRecordDao.save(record)
        }catch{
            Log.e("EventHandler Error: RecordCreated \(error)")
        }
    }
    
    private func when(event: TimerRecordCompleteSet){
        do{
            try timerRecordDao.updateComplete(
                recordId: event.recordId.id,
                endAt: event.timeRecord.endAt!,
                duration: event.timeRecord.duration!
            )
        }catch{
            Log.e("EventHandler Error: RecordCreated \(error)")
        }
    }
    
}

