//
//  RoutineRecordProjection.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation
import Combine


final class RoutineRecordProjection{
    
    private let routineTotalRecordDao: RoutineTotalRecordDao
    private let routineMonthRecordDao: RoutineMonthRecordDao
    private let routineWeekRecordDao: RoutineWeekRecordDao
    private let routineStreakDao: RoutineStreakDao
    private let routineRecordDao: RoutineRecordDao
    
    
    private var cancellables: Set<AnyCancellable>

    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
                
        self.routineRecordDao = dbManager.routineRecordDao
        self.routineTotalRecordDao = dbManager.routineTotalRecordDao
        self.routineMonthRecordDao = dbManager.routineMonthRecordDao
        self.routineWeekRecordDao = dbManager.routineWeekRecordDao
        self.routineStreakDao = dbManager.routineStreakDao
        
        cancellables = .init()
        
        registerReceiver()
    }
    
    
    private func registerReceiver(){
        DomainEventPublihser.shared
            .onReceive(RoutineRecordCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(RoutineRecordCompleteSet.self, action: when)
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
            try routineTotalRecordDao.complete(routineId: event.routineId.id)
            try routineMonthRecordDao.complete(routineId: event.routineId.id, recordMonth: Formatter.recordMonth(event.recordDate))
            try routineWeekRecordDao.complete(dto: RoutineWeekRecordDto(routineId: event.routineId.id, date: event.recordDate.date), dayOfWeek: event.recordDate.dayOfWeek)
            try routineStreakDao.complete(routineId: event.routineId.id, date: event.recordDate.date)
        }catch{
            Log.e("EventHandler Error: RecordCreated \(error)")
        }
    }
    
    private func when(event: RoutineRecordCompleteSet){
        do{
            if event.isComplete{
                try routineRecordDao.complete(recordId: event.recordId.id, completeAt: event.occurredOn)
                try routineTotalRecordDao.complete(routineId: event.routineId.id)
                try routineMonthRecordDao.complete(routineId: event.routineId.id, recordMonth: Formatter.recordMonth(event.recordDate))
                try routineWeekRecordDao.complete(dto: RoutineWeekRecordDto(routineId: event.routineId.id, date: event.recordDate.date), dayOfWeek: event.recordDate.dayOfWeek)
                try routineStreakDao.complete(routineId: event.routineId.id, date: event.recordDate.date)
            }else{
                try routineRecordDao.cancel(recordId: event.recordId.id, completeAt: event.occurredOn)
                try routineTotalRecordDao.cancel(routineId: event.routineId.id)
                try routineMonthRecordDao.cancel(routineId: event.routineId.id, recordMonth: Formatter.recordMonth(event.recordDate))
                try routineWeekRecordDao.cancel(dto: RoutineWeekRecordDto(routineId: event.routineId.id, date: event.recordDate.date), dayOfWeek: event.recordDate.dayOfWeek)
                try routineStreakDao.cancel(routineId: event.routineId.id, date: event.recordDate.date)
            }
        }catch{
            Log.e("EventHandler Error: RecordCreated \(error)")
        }
    }
    
}

